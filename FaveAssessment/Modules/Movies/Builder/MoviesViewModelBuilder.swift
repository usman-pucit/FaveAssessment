//
//  MoviesViewModelBuilder.swift
//  FaveAssessment
//
//  Created by Muhammad Usman on 20/05/2021.
//

import UIKit
import RxSwift
import Foundation

struct MovieViewModelBuilder {
    static func prepareViewModel(movie: Movie, image: (String) -> Observable<UIImage?>)-> MovieViewModel{
        let uniqueId = UUID().uuidString+"\(Int.random(in: 0..<9))"
        return MovieViewModel(uuid: uniqueId,id: movie.id ?? 0, title: movie.title ?? "", poster: image(movie.poster_path ?? ""), rating: "\(movie.popularity ?? 0)", synopsis: movie.overview ?? "", duration: "\(movie.runtime ?? 0) mins", language: movie.original_language ?? "", genre: getGenreString(genres: movie.genre_ids), releaseDate: movie.release_date ?? "")
    }
    
    static func getGenreString(genres: [Int]?)-> String{
        return genres?.map({String(Genres(rawValue: $0)?.name ?? "")}).joined(separator: ", ") ?? ""
    }
}

enum Genres: Int {
    case Action = 28
    case Adventure = 12
    case Animation = 16
    case Comedy = 35
    case Crime = 80
    case Documentary = 99
    case Drama = 18
    case Family = 10751
    case Fantasy = 14
    case History = 36
    case Horror = 27
    case Music = 10402
    case Mystery = 9648
    case Romance = 10749
    case Science_Fiction = 878
    case TV_Movie = 10770
    case Thriller = 53
    case War = 10752
    case Western = 37
    
    var name: String {
        switch self {
        case .Action:
            return "Action"
        case .Adventure:
            return "Adventure"
        case .Animation:
            return "Animation"
        case .Comedy:
            return "Comedy"
        case .Crime:
            return "Crime"
        case .Documentary:
            return "Documentary"
        case .Drama:
            return "Drama"
        case .Family:
            return "Family"
        case .Fantasy:
            return "Fantasy"
        case .History:
            return "History"
        case .Horror:
            return "Horror"
        case .Music:
            return "Music"
        case .Mystery:
            return "Mystery"
        case .Romance:
            return "Romance"
        case .Science_Fiction:
            return "Science Fiction"
        case .TV_Movie:
            return "TV Movie"
        case .Thriller:
            return "Thriller"
        case .War:
            return "War"
        case .Western:
            return "Western"
        }
    }
}
