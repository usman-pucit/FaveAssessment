//
//  Date.swift
//  HahnAssignment
//
//  Created by Muhammad Usman on 06/12/2020.
//

import Foundation

struct Movies: Decodable {
    let items: [Movie]?
    let page : Int?
    let totalPages : Int?
    let totalResults : Int?
    
    enum CodingKeys: String, CodingKey {
        case items = "results"
        case page = "page"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}


struct Movie: Decodable {
    let adult : Bool?
    let backdrop_path : String?
    let genre_ids : [Int]?
    let id : Int?
    let original_language : String?
    let original_title : String?
    let overview : String?
    let popularity : Double?
    let poster_path : String?
    let release_date : String?
    let title : String?
    let video : Bool?
    let vote_average : Double?
    let vote_count : Int?

    enum CodingKeys: String, CodingKey {

        case adult = "adult"
        case backdrop_path = "backdrop_path"
        case genre_ids = "genre_ids"
        case id = "id"
        case original_language = "original_language"
        case original_title = "original_title"
        case overview = "overview"
        case popularity = "popularity"
        case poster_path = "poster_path"
        case release_date = "release_date"
        case title = "title"
        case video = "video"
        case vote_average = "vote_average"
        case vote_count = "vote_count"
    }
}
