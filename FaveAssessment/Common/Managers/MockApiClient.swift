//
//  MockApiClient.swift
//  FaveAssessment
//
//  Created by Muhammad Usman on 23/05/2021.
//

import UIKit
import RxSwift
import Foundation

final class MockApiClient: APIClientType {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func execute<T>(_ request: Request) -> Observable<FResult<T, FError>> where T : Decodable {
        return T.parseJSON(with: name).asObservable()
    }
    
    func loadImage(_ url: URL) -> Observable<UIImage?> {
        return .just(UIImage(named: "\(url.absoluteString)"))
    }
    
}
