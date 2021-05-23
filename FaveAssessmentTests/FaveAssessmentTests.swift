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
    
    
}
