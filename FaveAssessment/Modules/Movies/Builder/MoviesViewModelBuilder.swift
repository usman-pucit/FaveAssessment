//
//  MoviesViewModelBuilder.swift
//  FaveAssessment
//
//  Created by Muhammad Usman on 20/05/2021.
//

import Foundation

struct MovieViewModelBuilder {
    static func prepareViewModel(movie: Movie)-> MovieViewModel{
        return MovieViewModel(id: movie.id ?? 0, title: movie.title ?? "", subtitle: "", overview: movie.overview ?? "", poster: nil, rating: "")
    }
}
