//
//  MainViewModel.swift
//  FaveAssessment
//
//  Created by Muhammad Usman on 19/05/2021.
//

import UIKit
import RxCocoa
import RxSwift

/// define all states of view.
enum MoviesViewModelState {
    case show([MovieViewModel])
    case error(String)
    case noResults
}

protocol MoviesViewModelType {
    func fetchMovies(_ request: Request)
    func refreshMovies()
    func sortMovies(by type: SortMovies)
}

class MoviesViewModel {
    
    // MARK: - Properties
    var selectionSubject = PublishSubject<Int>()
    var showLoadingObservable: Observable<Bool> {
        return showLoadingSubject.asObservable()
    }
    
    var resultObservable: Observable<MoviesViewModelState> {
        return resultSubject.asObservable()
    }
    
    var currentPage = 1
    var totalPages = 1
    // MARK: - Private properties
  
    private var sortType: SortMovies = .date
    private let disposeBag = DisposeBag()
    private let showLoadingSubject = BehaviorSubject<Bool>(value: false)
    private let resultSubject = PublishSubject<MoviesViewModelState>()
    private let useCase: MoviesUseCaseType
    private var moviesArray = [Movie]()
    
    init(useCase: MoviesUseCaseType) {
        self.useCase = useCase
    }
}

extension MoviesViewModel: MoviesViewModelType {
    
    func refreshMovies(){
        self.moviesArray.removeAll()
        let request = Request.movies(page: 1)
        fetchMovies(request)
    }
    
    func fetchMovies(_ request: Request){
        showLoadingSubject.onNext(true)
        
        useCase.fetchMovies(request).subscribe { [weak self] response in
            guard let `self` = self else { return }
            switch response {
            case .success(let data):
                self.currentPage = data.page ?? 0
                self.totalPages = data.total_pages ?? 0
                if let movies = data.results, !movies.isEmpty {
                    self.moviesArray += movies
                    self.sortMovies(by: self.sortType)
                } else {
                    self.resultSubject.onNext(.noResults)
                }
            case .failure(let error):
                self.resultSubject.onNext(.error(error.associatedValue))
            }
        } onError: { error in
            self.resultSubject.onNext(.error(error.localizedDescription))
        } onCompleted: {
            self.showLoadingSubject.onNext(false)
        }.disposed(by: disposeBag)
    }
    
    private func makeDatasource(movies: [Movie]) -> [MovieViewModel] {
        return movies.map { [unowned self] movie in
            MovieViewModelBuilder.prepareViewModel(movie: movie, image: { poster in self.useCase.downloadImage(poster, size: .small) })
        }
    }
    
    func sortMovies(by type: SortMovies){
        self.sortType = type
        switch type {
        case .date:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.moviesArray = moviesArray.sorted(by: { dateFormatter.date(from: $0.release_date ?? "")!.compare(dateFormatter.date(from: $1.release_date ?? "")!) == .orderedDescending })
        case .a_z:
            self.moviesArray = moviesArray.sorted(by: { $0.title ?? "" < $1.title ?? "" })
        case .popularity:
            self.moviesArray = moviesArray.sorted(by: { $0.popularity ?? 0 > $1.popularity ?? 0 })
        }
        let datasource = Array(Set(self.makeDatasource(movies: self.moviesArray)))
        self.resultSubject.onNext(.show(datasource))
    }
}
