//
//  Request.swift
//  FaveAssessment
//
//  Created by Muhammad Usman on 19/05/2021.
//

import Foundation

enum FError: Error{
    case networkError
    case unknown(String)
    
    var associatedValue: String{
        switch self {
        case .unknown(let message):
            return message
        case .networkError:
            return "Network error"
        }
    }
}

enum FResult<Value,FError> {
    case success(Value)
    case failure(FError)
}

struct Request{
    var url: URL = URL(string: Environment.BASE_URL)!
    let parameters: [String: CustomStringConvertible]
    var request: URLRequest? {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        components.queryItems = parameters.keys.map { key in
            URLQueryItem(name: key, value: parameters[key]?.description)
        }
        guard let url = components.url else {
            return nil
        }
        return URLRequest(url: url)
    }

    init(parameters: [String: CustomStringConvertible] = [:]) {
        self.parameters = parameters
    }
}
