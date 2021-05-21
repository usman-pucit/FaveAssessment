//
//  MoviesUseCase.swift
//  FaveAssessment
//
//  Created by Muhammad Usman on 19/05/2021.
//

import Foundation
import RxSwift
import UIKit

enum PosterSize{
    case small
    case original
}

/// Abstract functions
protocol MoviesUseCaseType {
    func fetchMovies(_ request: Request) -> Observable<FResult<Movies, FError>>
    func fetchMovieDetails(_ request: Request) -> Observable<FResult<Movie, FError>>
    func downloadImage(_ poster: String, size: PosterSize) -> Observable<UIImage?>
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

    func fetchMovieDetails(_ request: Request) -> Observable<FResult<Movie, FError>>{
        return apiClient.execute(request)
    }
    
    func downloadImage(_ poster: String, size: PosterSize) -> Observable<UIImage?>{
        let url : URL!
        if size == .original {
            url = Environment.ORIGINAL_IMAGE_URL
        }else{
            url = Environment.TMDB_IMAGE_URL
        }
        let imageURL = url.appendingPathComponent(poster)
        return apiClient
            .loadImage(imageURL)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .asObservable()
    }
}
