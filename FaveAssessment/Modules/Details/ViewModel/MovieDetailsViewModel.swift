//
//  MovieDetailsViewModel.swift
//  FaveAssessment
//
//  Created by Muhammad Usman on 20/05/2021.
//

import RxSwift
import Foundation

enum MovieDetailsViewModelState {
    case show(MovieViewModel)
    case error(String)
}

protocol MovieDetailsViewModelType {
    // Properties
    var movieId: Int! {get set}
    var showLoadingObservable: Observable<Bool>! {get}
    var resultObservable: Observable<MovieDetailsViewModelState>! {get}
    
    // Functions
    func fetchMovieDetails(_ request: Request)
}

class MovieDetailsViewModel {
    
    // MARK: - Properties
    
    var movieId: Int!
    var showLoadingObservable: Observable<Bool>! {
        return showLoadingSubject.asObservable()
    }
    
    var resultObservable: Observable<MovieDetailsViewModelState>! {
        return resultSubject.asObservable()
    }
    
    // MARK: - Private properties
    private let useCase: MoviesUseCaseType
    private let disposeBag = DisposeBag()
    private let showLoadingSubject = BehaviorSubject<Bool>(value: false)
    private let resultSubject = PublishSubject<MovieDetailsViewModelState>()
    
    init(useCase: MoviesUseCaseType) {
        self.useCase = useCase
    }
}

extension MovieDetailsViewModel: MovieDetailsViewModelType{

    func fetchMovieDetails(_ request: Request) {
        showLoadingSubject.onNext(true)
        
        useCase.fetchMovieDetails(request).subscribe { [weak self] response in
            guard let `self` = self else { return }
            switch response {
            case .success(let movie):
                self.resultSubject.onNext(.show(self.makeDatasource(movie: movie)))
            case .failure(let error):
                self.resultSubject.onNext(.error(error.associatedValue))
            }
        } onError: { error in
            self.resultSubject.onNext(.error(error.localizedDescription))
        } onCompleted: {
            self.showLoadingSubject.onNext(false)
        }.disposed(by: disposeBag)
    }
    
    private func makeDatasource(movie: Movie) -> MovieViewModel {
        return MovieViewModelBuilder.prepareViewModel(movie: movie, image: { poster in self.useCase.downloadImage(poster) })
    }
}
