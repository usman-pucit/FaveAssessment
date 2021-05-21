//
//  MainViewController.swift
//  FaveAssessment
//
//  Created by Muhammad Usman on 19/05/2021.
//

import DropDown
import RxSwift
import UIKit

// Locally movies sorting enum
enum SortMovies: Int {
    case date = 0
    case a_z
    case popularity
}

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
        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
        tableView.registerNib(cellClass: MovieTableViewCell.self)
        tableView.dataSource = dataSource
        
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
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
                if let value = event.element, value, !self.isLoadingWithRefreshControl {
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

        tableView.rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let `self` = self else { return }
                self.viewModel.selectionSubject.onNext(self.dataSource.snapshot().itemIdentifiers[indexPath.row].id)
                self.tableView.deselectRow(at: indexPath, animated: true)
            }).disposed(by: disposeBag)
        
        tableView.rx
            .willDisplayCell
            .subscribe(onNext: { [weak self] _, indexPath in
                guard let `self` = self else { return }
                if self.viewModel.currentPage < self.viewModel.totalPages, indexPath.row == self.dataSource.snapshot().numberOfItems - 1 {
                    self.viewModel.currentPage += 1
                    self.fetchMovies()
                }
            }).disposed(by: disposeBag)
        
        /// network call to fetch movies
        fetchMovies()
    }
    
    private func fetchMovies() {
        let request = Request.movies(page: viewModel.currentPage)
        viewModel.fetchMovies(request, isRefresh: isLoadingWithRefreshControl)
    }
    
    private func handleResponse(_ result: MoviesViewModelState) {
        switch result {
        case .show(let movies):
            configure(with: movies)
        case .noResults:
            handleError("No results")
        case .error(let message):
            handleError(message)
        }
    }
    
    private func handleError(_ message: String) {}
    
    @IBAction func filterTapped(_ sender: UIBarButtonItem) {
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = ["Release date", "A to Z", "Popularity"]
        
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, _: String) in
            if let sortType = SortMovies(rawValue: index) {
                self.viewModel.sortMovies(by: sortType)
            }
            dropDown.hide()
        }
        dropDown.show()
    }
}

private extension MoviesViewController {
    enum Section: CaseIterable {
        case movies
    }
    
    func makeDataSource() -> UITableViewDiffableDataSource<Section, MovieViewModel> {
        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { tableView, _, movieViewModel in
                guard let cell = tableView.dequeueReusableCell(withClass: MovieTableViewCell.self) else {
                    assertionFailure("Failed to dequeue \(MovieTableViewCell.self)!")
                    return UITableViewCell()
                }
                cell.configure(with: movieViewModel)
                return cell
            }
        )
    }
    
    func configure(with movies: [MovieViewModel], animate: Bool = true) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section, MovieViewModel>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(movies, toSection: .movies)
            self.dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
}
