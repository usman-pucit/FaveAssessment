//
//  MoviesUseCase.swift
//  FaveAssessment
//
//  Created by Muhammad Usman on 19/05/2021.
//

import RxSwift
import Foundation


/// Abstract functions
protocol MoviesUseCaseType {
    func fetchMovies(_ request: Request) -> Observable<FResult<Movies, FError>>
}

/**
 Movies listing use-case
 */
class MoviesUseCase{
    var apiClient: APIClientType
    
    init(apiClient: APIClientType = APIClient()) {
        self.apiClient = apiClient
    }
}

/// Extension
extension MoviesUseCase: MoviesUseCaseType{
    func fetchMovies(_ request: Request) -> Observable<FResult<Movies, FError>>{
        return apiClient.execute(request)
    }
}

