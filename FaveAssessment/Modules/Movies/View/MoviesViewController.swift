//
//  MainViewController.swift
//  FaveAssessment
//
//  Created by Muhammad Usman on 19/05/2021.
//

import RxSwift
import UIKit

/**
    Movies listing view controller
    Sorted list based on `Release date`, `Alphabetical order`,  `Rating`
 */
class MoviesViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    var viewModel: MoviesViewModel!
    private let disposeBag = DisposeBag()
    private lazy var dataSource = makeDataSource()
    private lazy var refreshControl = UIRefreshControl()
    private var isLoadingWithRefreshControl = false
    // MARK: - Lifecycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
    }
    
    /// Function to configure UI
    private func configureUI() {
        title = "Movies"
        tableView.tableFooterView = UIView()
        tableView.registerNib(cellClass: MovieTableViewCell.self)
        tableView.dataSource = dataSource
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
       isLoadingWithRefreshControl = true
       fetchMovies()
    }
    
    /// Function to bind UI with ViewModel
    private func bindUI() {
        /// binding activity loader
        viewModel.showLoadingObservable.subscribe { event in
            DispatchQueue.main.async {
                if let value = event.element, value && !self.isLoadingWithRefreshControl {
                    self.activityIndicator.startAnimating()
                } else {
                    self.isLoadingWithRefreshControl = false
                    self.refreshControl.endRefreshing()
                    self.activityIndicator.stopAnimating()
                }
            }
        }.disposed(by: disposeBag)
        
        /// binding `fetchMovies` results with UI
        viewModel.resultObservable.subscribe { result in
            self.handleResponse(result)
        } onError: { error in
            self.handleError(error.localizedDescription)
        }.disposed(by: disposeBag)
        
        /// network call to fetch movies
        fetchMovies()
    }
    
    
    private func fetchMovies(){
        var parameters = [String: String]()
        parameters["api_key"] = Environment.TMDB_API_KEY
        parameters["primary_release_date.lte"] = "2016-12-31"
        parameters["sort_by"] = "release_date.desc"
        parameters["page"] = "1"
        
        let request = Request(parameters: parameters)
        viewModel.fetchMovies(request)
    }
    
    private func handleResponse(_ result: MoviesViewModelState) {
        switch result {
        case .show(let movies):
            load(with: movies)
        case .noResults:
            handleError("No results")
        case .error(let message):
            handleError(message)
        }
    }
    
    private func handleError(_ message: String) {
        
    }
}

fileprivate extension MoviesViewController{
    enum Section: CaseIterable {
        case movies
    }
    
    func makeDataSource() -> UITableViewDiffableDataSource<Section, MovieViewModel> {
        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, movieViewModel in
                guard let cell = tableView.dequeueReusableCell(withClass: MovieTableViewCell.self) else {
                    assertionFailure("Failed to dequeue \(MovieTableViewCell.self)!")
                    return UITableViewCell()
                }
                cell.configure(with: movieViewModel)
                return cell
            }
        )
    }
    
    func load(with movies: [MovieViewModel], animate: Bool = true) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section, MovieViewModel>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(movies, toSection: .movies)
            self.dataSource.apply(snapshot, animatingDifferences: animate)
        }
    }
}
