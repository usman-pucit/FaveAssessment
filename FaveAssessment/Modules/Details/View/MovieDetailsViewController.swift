//
//  MovieDetailsViewController.swift
//  FaveAssessment
//
//  Created by Muhammad Usman on 20/05/2021.
//

import UIKit
import RxSwift

// MARK: - Class
// Movie details view controller

class MovieDetailsViewController: UIViewController{
    
    // MARK: - IBOutlets

    @IBOutlet private var posterImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var languageLabel: UILabel!
    @IBOutlet private var durationLabel: UILabel!
    @IBOutlet private var genreLabel: UILabel!
    @IBOutlet private var synopsisLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    var viewModel: MovieDetailsViewModelType!
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
    }
    
    private func configureUI(){
        title = "Details"
        overrideUserInterfaceStyle = .dark
    }
    
    private func bindUI(){
        /// binding activity loader
        viewModel.showLoadingObservable.subscribe { event in
            DispatchQueue.main.async {
                if let value = event.element, value{
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
            }
        }.disposed(by: disposeBag)
        
        /// binding `fetchMovies` results with view
        viewModel.resultObservable.subscribe { result in
            self.handleResponse(result)
        } onError: { error in
            self.handleError(error.localizedDescription)
        }.disposed(by: disposeBag)

        fetchMovieDetails()
    }
    
    private func fetchMovieDetails(){
        let request = Request.details(movieId: viewModel.movieId)
        viewModel.fetchMovieDetails(request)
    }
    
    private func handleResponse(_ result: MovieDetailsViewModelState) {
        switch result {
        case .show(let movie):
            DispatchQueue.main.async {
                self.configure(movie)
            }
        case .error(let message):
            handleError(message)
        }
    }
    
    private func handleError(_ message: String) {
        DispatchQueue.main.async {
            self.showAlert(with: "Error", message: message)
        }
    }
    
    private func configure(_ movie: MovieViewModel){
        synopsisLabel.text = movie.synopsis
        titleLabel.text = movie.title
        durationLabel.text = "Time: "+movie.duration
        languageLabel.text = "Language: "+movie.language
        genreLabel.text = movie.genre
        movie
            .poster
            .bind(to: posterImageView.rx.image)
            .disposed(by: disposeBag)
    }
}
