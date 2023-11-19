//
//  MovieDetailViewModelTests.swift
//  MoviesTests
//
//  Created by Ajay Babu Singineedi on 19/11/23.
//  Copyright © 2023 ajay Babu. All rights reserved.
//

import XCTest
@testable import Movies

class MovieDetailViewModelTests: XCTestCase {
    var viewModel: MovieDetailViewModel!
    lazy var mockMoviesRepository: MockMoviesRepository = {
        let mockAPIManager = MockAPIManager()
        let mockRealmManager = MockRealmManager()
        let dependencies = MovieDependencyFactoryImpl(movieAPIManager: mockAPIManager, movieRalmManager: mockRealmManager)
        let mockMovieRepository = MockMoviesRepository(dependencies: dependencies)
        return mockMovieRepository
    }()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = MovieDetailViewModel(repository: mockMoviesRepository, id: 1)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }

    func testInitialization() {
        XCTAssertNotNil(viewModel.repository, "Repository must not be nil on view model.")
    }
    
    func testViewModel_FetchMovieDetail_ShouldSuceedWithResponse() {
        viewModel.fetchMovieDetails(for: 1) {[weak self] success in
            guard let self = self else { XCTFail()
                return
            }
            XCTAssertTrue(success)
            XCTAssertNotNil(self.viewModel.movieDetail)
            XCTAssertEqual(self.viewModel.movieDetail?.title ?? "", "Five Nights at Freddy's")
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
