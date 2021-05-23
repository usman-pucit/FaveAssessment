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
    
    var viewModel: MoviesViewModel!
    var disposeBag = DisposeBag()
    var useCase: MoviesUseCaseType!
    
    override func setUp() {
        useCase = MoviesUseCase(apiClient: MockApiClient())
        viewModel = MoviesViewModel(useCase: useCase)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
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
    
    func testSortingOne(){
        viewModel.fetchMovies(Request())
        let expectation = XCTestExpectation(description: "Date fetched")
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
    
    func testSortingTwo(){
        viewModel.fetchMovies(Request())
        let expectation = XCTestExpectation(description: "Date fetched")
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
    
    func testSortingThree(){
        viewModel.fetchMovies(Request())
        let expectation = XCTestExpectation(description: "Date fetched")
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
}
