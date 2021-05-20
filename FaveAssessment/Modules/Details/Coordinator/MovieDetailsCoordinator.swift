//
//  MovieDetailsCoordinator.swift
//  FaveAssessment
//
//  Created by Muhammad Usman on 20/05/2021.
//

import Foundation
import RxSwift
import UIKit

class MovieDetailsCoordinator: RxCoordinator<Void> {
    let rootViewController: UIViewController
    public var movieId: Int!

    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }

    override func start() -> Observable<Void> {
        let viewController = MovieDetailsViewController.instantiate(fromAppStoryboard: .Main)
        let viewModel = MovieDetailsViewModel(useCase: MoviesUseCase())
        viewModel.movieId = movieId
        viewController.viewModel = viewModel
        rootViewController.navigationController?
            .pushViewController(viewController, animated: true)

        return Observable.never()
            .take(1)
    }
}
