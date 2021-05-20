//
//  MovieViewModel.swift
//  FaveAssessment
//
//  Created by Muhammad Usman on 20/05/2021.
//

import UIKit
import RxSwift
import Foundation

struct MovieViewModel {
    let id: Int
    let title: String
    let poster: Observable<UIImage?>
    let rating: String

    init(id: Int, title: String, poster: Observable<UIImage?>, rating: String) {
        self.id = id
        self.title = title
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
