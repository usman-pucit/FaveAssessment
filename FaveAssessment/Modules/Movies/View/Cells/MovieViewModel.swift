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
    let synopsis: String
    let duration: String
    let language: String
    let genre: String
}

extension MovieViewModel: Hashable {
    static func == (lhs: MovieViewModel, rhs: MovieViewModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
