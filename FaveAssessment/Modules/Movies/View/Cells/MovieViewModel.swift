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
    let uuid : String
    let id: Int
    let title: String
    let poster: Observable<UIImage?>
    let rating: String
    let synopsis: String
    let duration: String
    let language: String
    let genre: String
    let releaseDate: String
}

extension MovieViewModel: Hashable {
    static func == (lhs: MovieViewModel, rhs: MovieViewModel) -> Bool {
        return lhs.uuid == rhs.uuid && lhs.title == rhs.title
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
