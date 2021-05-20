//
//  MainCoordinator.swift
//  FaveAssessment
//
//  Created by Muhammad Usman on 19/05/2021.
//

import UIKit
import RxSwift

class MoviesCoordinator: RxCoordinator<Void> {
    
    let rootViewController: UIViewController
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<Void> {
        
        let viewController = rootViewController as! MoviesViewController
        let viewModel = MoviesViewModel(useCase: MoviesUseCase())
        viewController.viewModel = viewModel
        
        viewModel.selectionSubject.subscribe({ event in
            if let movieId = event.element{
                self.coordinateToMovieDetails(movieId)
            }
        }).disposed(by: disposeBag)
        return Observable.never()
    }
    
    private func coordinateToMovieDetails(_ movieId: Int) -> Observable<Void>{
        let movieDetailCoordinator = MovieDetailsCoordinator(rootViewController: rootViewController)
        movieDetailCoordinator.movieId = movieId
        return coordinate(to: movieDetailCoordinator)
            .map { _ in () }
    }
}
