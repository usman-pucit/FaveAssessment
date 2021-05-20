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
        return MovieViewModel(id: movie.id ?? 0, title: movie.title ?? "", poster: image(movie.poster_path ?? ""), rating: "\(movie.popularity ?? 0)")
    }
}
