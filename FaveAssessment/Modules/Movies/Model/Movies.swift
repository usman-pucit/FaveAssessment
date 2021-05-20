//
//  Date.swift
//  FaveAssessment
//
//  Created by Muhammad Usman on 19/05/2021.
//

import Foundation

struct Movies: Decodable {
    let results: [Movie]?
    let page : Int?
    let total_pages : Int?
    let total_results : Int?
}


struct Movie: Decodable {
    let adult : Bool?
    let backdrop_path : String?
    let budget : Int?
    let genres : [Genres]?
    let homepage : String?
    let id : Int?
    let imdb_id : String?
    let original_language : String?
    let original_title : String?
    let overview : String?
    let popularity : Double?
    let poster_path : String?
    let release_date : String?
    let revenue : Int?
    let runtime : Int?
    let status : String?
    let tagline : String?
    let title : String?
    let video : Bool?
    let vote_average : Double?
    let vote_count : Int?
}

struct Genres : Decodable {
    let id : Int?
    let name : String?
}
