//
//  Decodable.swift
//  FaveAssessment
//
//  Created by Muhammad Usman on 23/05/2021.
//

import RxSwift
import Foundation

// MARK: - Extension

extension Decodable {
    // MARK: - Function

    static func parseJSON(with fileName: String) -> Observable<FResult<Self, FError>> {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let output = try? JSONDecoder().decode(self, from: data)

        else {
            return .just(.failure(.unknown("Failed to load JSON")))
        }
        return .just(.success(output))
    }
}
