//
//  MovieDetailsViewModelTests.swift
//  FaveAssessmentTests
//
//  Created by Muhammad Usman on 24/05/2021.
//

import XCTest
import RxSwift
@testable import FaveAssessment

class MovieDetailsViewModelTests: XCTestCase{
    
    // MARK: - Propeties
    var viewModel: MovieDetailsViewModel!
    var disposeBag = DisposeBag()
    var useCase: MoviesUseCaseType!
    
    // MARK: Override function
    override func setUp() {
        useCase = MoviesUseCase(apiClient: MockApiClient(name: "Mock-Details"))
        viewModel = MovieDetailsViewModel(useCase: useCase)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    
    /**
     Test function 1
     Testing movie details request
     */
    
    func testMovieDetailsRequest(){
        let expectation = XCTestExpectation(description: "Date fetched")
        viewModel.fetchMovieDetails(Request())
        
        viewModel.resultObservable.subscribe { result in
            switch result{
            case .show(let movie):
                if  movie.title == "ABC" {
                    expectation.fulfill()
                }else{
                    XCTAssert(false, "Failed")
                }
            case .error(_):
                XCTAssert(false, "Failed")
            }
        } onError: { error in
            XCTAssert(false, "Failed")
        }.disposed(by: disposeBag)
    }
    
    /**
     Test function 2
     Testing activity loader showing properly 
     */
    
    func testActivityLoader(){
        let expectation = XCTestExpectation(description: "Loader showing")
        viewModel.fetchMovieDetails(Request())
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

