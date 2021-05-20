//
//  MovieTableViewCell.swift
//  TMDB
//
//  Created by Maksym Shcheglov on 05/10/2019.
//  Copyright © 2019 Maksym Shcheglov. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

// Cell
class MovieTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var ratingLabel: UILabel!
    @IBOutlet private var posterImageView: UIImageView!

    // MARK: - Properties
    private let disposeBag = DisposeBag()

    // MARK: - Configure Cell
    func configure(with viewModel: MovieViewModel) {
        titleLabel.text = viewModel.title
        ratingLabel.text = viewModel.rating
        viewModel
            .poster
            .bind(to: posterImageView.rx.image)
            .disposed(by: disposeBag)
    }
}
