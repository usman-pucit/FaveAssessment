//
//  MainViewModel.swift
//  FaveAssessment
//
//  Created by Muhammad Usman on 19/05/2021.
//

import RxCocoa
import RxSwift

/// define all states of view.
enum MoviesViewModelState {
    case show([MovieViewModel])
    case error(String)
}

protocol MoviesViewModelType {
    func fetchMovies(_ request: Request)
}

class MoviesViewModel {
    
    // MARK: - Properties
    var showLoadingObservable : Observable<Bool> {
        return showLoadingSubject.asObservable()
    }
    
    var resultObservable : Observable<MoviesViewModelState> {
        return resultSubject.asObservable()
    }
    
    // MARK: - Private properties
    
    private let disposeBag = DisposeBag()
    private let showLoadingSubject = BehaviorSubject<Bool>(value: false)
    private let resultSubject = PublishSubject<MoviesViewModelState>()
    private let useCase: MoviesUseCaseType
    
    init(useCase: MoviesUseCaseType) {
        self.useCase = useCase
    }
}

extension MoviesViewModel: MoviesViewModelType{
    
    func fetchMovies(_ request: Request){
        showLoadingSubject.onNext(true)
        
        useCase.fetchMovies(request).subscribe { [weak self] response in
            guard let `self` = self else {return}
            switch response{
            case .success(let data):
                self.resultSubject.onNext(.show(self.makeDatasource(movies: data.items ?? [])))
            case .failure(let error):
                self.resultSubject.onNext(.error(error.associatedValue))
            }
        } onError: { error in
            self.resultSubject.onNext(.error(error.localizedDescription))
        } onCompleted: {
            self.showLoadingSubject.onNext(false)
        }.disposed(by: disposeBag)

    }
    
    private func makeDatasource(movies: [Movie]) -> [MovieViewModel]{
        return movies.map({ movie in
            return MovieViewModelBuilder.prepareViewModel(movie: movie)
        })
    }
}