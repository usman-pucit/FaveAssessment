//
//  MovieViewModel.swift
//  FaveAssessment
//
//  Created by Muhammad Usman on 20/05/2021.
//

import UIKit.UIImage
import Foundation

struct MovieViewModel {
    let id: Int
    let title: String
    let subtitle: String
    let overview: String
    let poster: UIImage?
    let rating: String

    init(id: Int, title: String, subtitle: String, overview: String, poster: UIImage?, rating: String) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.overview = overview
        self.poster = poster
        self.rating = rating
    }
}

extension MovieViewModel: Hashable {
    static func == (lhs: MovieViewModel, rhs: MovieViewModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
