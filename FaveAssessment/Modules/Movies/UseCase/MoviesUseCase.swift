//
//  MoviesUseCase.swift
//  FaveAssessment
//
//  Created by Muhammad Usman on 19/05/2021.
//

import Foundation
import RxSwift
import UIKit

/// Abstract functions
protocol MoviesUseCaseType {
    func fetchMovies(_ request: Request) -> Observable<FResult<Movies, FError>>
    func downloadImage(_ poster: String) -> Observable<UIImage?>
}

/**
 Movies listing use-case
 */
class MoviesUseCase {
    var apiClient: APIClientType

    init(apiClient: APIClientType = APIClient()) {
        self.apiClient = apiClient
    }
}

/// Extension
extension MoviesUseCase: MoviesUseCaseType {
    func fetchMovies(_ request: Request) -> Observable<FResult<Movies, FError>> {
        return apiClient.execute(request)
    }

    func downloadImage(_ poster: String) -> Observable<UIImage?> {
        let url = Environment.TMDB_IMAGE_URL.appendingPathComponent(poster)
        return apiClient
            .loadImage(url)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .asObservable()
    }
}
