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
        return MovieViewModel(id: movie.id ?? 0, title: movie.title ?? "", poster: image(movie.poster_path ?? ""), rating: "\(movie.popularity ?? 0)", synopsis: movie.overview ?? "", duration: "\(movie.runtime ?? 0) mins", language: movie.original_language ?? "", genre: getGenreString(genres: movie.genres))
    }
    
    static func getGenreString(genres: [Genres]?)-> String{
        return genres?.map({$0.name ?? ""}).joined(separator: ", ") ?? ""
    }
}
