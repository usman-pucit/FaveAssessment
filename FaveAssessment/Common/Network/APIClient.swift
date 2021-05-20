//
//  APIClient.swift
//  FaveAssessment
//
//  Created by Muhammad Usman on 19/05/2021.
//

import Foundation
import RxSwift

protocol APIClientType{
    @discardableResult
    func execute<T>(_ request: Request) -> Observable<FResult<T, FError>> where T: Decodable
}

class APIClient: APIClientType{
    // MARK: - Function
    
    @discardableResult
    func execute<T>(_ request: Request) -> Observable<FResult<T, FError>> where T : Decodable {
        guard let request = request.request else {
            return .just(.failure(.networkError))
        }
        
       return URLSession.shared.rx.response(request: request)
        .map(\.data)
        .decode(type: T.self, decoder: JSONDecoder())
        .map { response -> FResult<T, FError> in
            return .success(response)
        }
        .catch ({ error -> Observable<FResult<T, FError>> in
            return .just(.failure(FError.unknown(error.localizedDescription)))
        })
    }
}
