//
//  FaveAssessmentTests.swift
//  FaveAssessmentTests
//
//  Created by Muhammad Usman on 19/05/2021.
//

import XCTest
import RxSwift
@testable import FaveAssessment

class MoviesViewModelTests: XCTestCase{
    
    // MARK: Properties
    var viewModel: MoviesViewModel!
    var disposeBag = DisposeBag()
    var useCase: MoviesUseCaseType!
    
    // MARK: Override function
    
    override func setUp() {
        useCase = MoviesUseCase(apiClient: MockApiClient(name: "Mock"))
        viewModel = MoviesViewModel(useCase: useCase)
    }
    
    override func tearDown() {
        viewModel = nil
        useCase = nil
        super.tearDown()
    }
    
    /**
     Test function 1
     Testing fetch movies request
     */
    
    func testFetchMoviesRequest(){
        viewModel.fetchMovies(Request())
        let expectation = XCTestExpectation(description: "Date fetched")
        
        viewModel.resultObservable.subscribe { result in
            switch result {
            case .show(_):
                expectation.fulfill()
            case .noResults:
                XCTAssert(false, "Failed")
            case .error(_):
                XCTAssert(false, "Failed")
            }
        } onError: { error in
            XCTAssert(false, "Failed")
        }.disposed(by: disposeBag)
        
    }
    
    /**
     Test function 2
     Testing movies sorting function with  `popularity`sorting
     */
    
    func testSortingOne(){
        viewModel.fetchMovies(Request())
        let expectation = XCTestExpectation(description: "Sorting confirmed")
        viewModel.sortType = .popularity
        viewModel.resultObservable.subscribe { result in
            switch result {
            case .show(let movies):
                if let movie = movies.first, movie.rating == "100" && movie.title == "XYZ"{
                    expectation.fulfill()
                }else{
                    XCTAssert(false, "Failed")
                }
            case .noResults:
                XCTAssert(false, "Failed")
            case .error(_):
                XCTAssert(false, "Failed")
            }
        } onError: { error in
            XCTAssert(false, "Failed")
        }.disposed(by: disposeBag)
    }
    
    /**
     Test function 3
     Testing movies sorting function with  `a_z`sorting
     */
    
    func testSortingTwo(){
        viewModel.fetchMovies(Request())
        let expectation = XCTestExpectation(description: "Sorting confirmed")
        viewModel.sortType = .a_z
        viewModel.resultObservable.subscribe { result in
            switch result {
            case .show(let movies):
                if let movie = movies.first, movie.rating == "10" && movie.title == "ABC"{
                    expectation.fulfill()
                }else{
                    XCTAssert(false, "Failed")
                }
            case .noResults:
                XCTAssert(false, "Failed")
            case .error(_):
                XCTAssert(false, "Failed")
            }
        } onError: { error in
            XCTAssert(false, "Failed")
        }.disposed(by: disposeBag)
    }
    
    /**
     Test function 4
     Testing movies sorting function with  `date`sorting
     */
    
    func testSortingThree(){
        viewModel.fetchMovies(Request())
        let expectation = XCTestExpectation(description: "Sorting confirmed")
        viewModel.sortType = .date
        viewModel.resultObservable.subscribe { result in
            switch result {
            case .show(let movies):
                if let movie = movies.first, movie.rating == "10" && movie.title == "ABC"{
                    expectation.fulfill()
                }else{
                    XCTAssert(false, "Failed")
                }
            case .noResults:
                XCTAssert(false, "Failed")
            case .error(_):
                XCTAssert(false, "Failed")
            }
        } onError: { error in
            XCTAssert(false, "Failed")
        }.disposed(by: disposeBag)
    }
    
    /**
     Test function 5
     Test activity loader working properly
     */
    
    func testActivityLoader(){
        let expectation = XCTestExpectation(description: "Loader showing")
        viewModel.fetchMovies(Request())
        var isLoading = false
        viewModel.showLoadingObservable.skip(1).subscribe { event in
            if let value = event.element, value{
                isLoading = true
            }else{
                if isLoading {
                    isLoading = false
                    expectation.fulfill()
                }else{
                    XCTAssert(false, "Failed")
                }
            }
        }
    }
}
