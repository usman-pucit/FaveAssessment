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
    var url: URL
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

    init(url: URL = Environment.BASE_URL, parameters: [String: CustomStringConvertible] = [:]) {
        self.url = url
        self.parameters = parameters
    }
}

extension Request{
    
    static func movies() -> Request {
        let url = Environment.BASE_URL.appendingPathComponent("/discover/movie")
        let parameters: [String : CustomStringConvertible] = [
            "api_key": Environment.TMDB_API_KEY,
            "primary_release_date.lte": "2016-12-31",
            "sort_by": "release_date.desc",
            "page": "1"
            ]
        return Request(url: url, parameters: parameters)
    }

    static func details(movieId: Int) -> Request {
        let url = Environment.BASE_URL.appendingPathComponent("/movie/\(movieId)")
        let parameters: [String : CustomStringConvertible] = [
            "api_key": Environment.TMDB_API_KEY,
            "primary_release_date.lte": "2016-12-31",
            "sort_by": "release_date.desc",
            "page": "1"
            ]
        return Request(url: url, parameters: parameters)
    }
}
