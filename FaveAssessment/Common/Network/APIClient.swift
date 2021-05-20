//
//  APIClient.swift
//  FaveAssessment
//
//  Created by Muhammad Usman on 19/05/2021.
//

import Foundation
import RxSwift
import UIKit

protocol APIClientType {
    @discardableResult
    func execute<T>(_ request: Request) -> Observable<FResult<T, FError>> where T: Decodable
    func loadImage(_ url: URL) -> Observable<UIImage?>
}

class APIClient: APIClientType {
    private let cache = ImageCacheManager()

    @discardableResult
    func execute<T>(_ request: Request) -> Observable<FResult<T, FError>> where T: Decodable {
        guard let request = request.request else {
            return .just(.failure(.networkError))
        }

        return URLSession.shared.rx.response(request: request)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .map { response -> FResult<T, FError> in
                .success(response)
            }
            .catch { error -> Observable<FResult<T, FError>> in
                .just(.failure(FError.unknown(error.localizedDescription)))
            }
    }
}

extension APIClient {
    func loadImage(_ url: URL) -> Observable<UIImage?> {
        if let image = cache.image(for: url) {
            return .just(image)
        }
        return URLSession.shared.rx.response(request: URLRequest(url: url))
            .map { (_, data) -> UIImage? in
                if let image = UIImage(data: data) {
                    self.cache.insertImage(image, for: url)
                    return image
                } else {
                    return nil
                }
            }
            .catch { error -> Observable<UIImage?> in
                return .just(nil)
            }
    }
}
