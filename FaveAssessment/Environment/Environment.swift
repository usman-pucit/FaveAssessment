//
//  Environment.swift
//  FaveAssessment
//
//  Created by Muhammad Usman on 20/05/2021.
//

import Foundation

public enum Environment {
    // MARK: - Keys
    
    enum Keys {
        enum Plist {
            static let BASE_URL = "BASE_URL"
            static let API_KEY = "API_KEY"
        }
    }
    
    // MARK: - Plist
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
    
    static let BASE_URL: String = {
        guard let baseURL = Environment.infoDictionary[Keys.Plist.BASE_URL] as? String else{
            fatalError("BASE_URL not found")
        }
        return baseURL
    }()
    
    static let TMDB_API_KEY: String = {
        guard let api = Environment.infoDictionary[Keys.Plist.API_KEY] as? String else{
            fatalError("TMDB_API_KEY not found")
        }
        return api
    }()
}

