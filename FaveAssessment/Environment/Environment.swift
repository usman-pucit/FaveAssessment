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
            static let IMAGE_URL = "IMAGE_URL"
            static let ORIGINAL_IMAGE_URL = "ORIGINAL_IMAGE_URL"
        }
    }
    
    // MARK: - Plist
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
    
    static let BASE_URL: URL = {
        guard let urlString = Environment.infoDictionary[Keys.Plist.BASE_URL] as? String, let baseURL = URL(string: urlString) else{
            fatalError("BASE_URL not found")
        }
        return baseURL
    }()
    
    static let TMDB_API_KEY: String = {
        guard let key = Environment.infoDictionary[Keys.Plist.API_KEY] as? String else{
            fatalError("TMDB_API_KEY not found")
        }
        return key
    }()
    
    static let TMDB_IMAGE_URL: URL = {
        guard let urlString = Environment.infoDictionary[Keys.Plist.IMAGE_URL] as? String, let url = URL(string: urlString) else{
            fatalError("IMAGE_URL not found")
        }
        return url
    }()
    
    static let ORIGINAL_IMAGE_URL: URL = {
        guard let urlString = Environment.infoDictionary[Keys.Plist.ORIGINAL_IMAGE_URL] as? String, let url = URL(string: urlString) else{
            fatalError("ORIGINAL_IMAGE_URL not found")
        }
        return url
    }()
}

