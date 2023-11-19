//
//  MoviesTests.swift
//  MoviesTests
//
//  Created by ajay Babu on 17/11/23.
//  Copyright © 2023 ajay Babu. All rights reserved.
//

import XCTest
@testable import Movies

class MovieViewModelTests: XCTestCase {
    var viewModel: MovieViewModel!
    lazy var mockMoviesRepository: MockMoviesRepository = {
        let mockAPIManager = MockAPIManager()
        let mockRealmManager = MockRealmManager()
        let dependencies = MovieDependencyFactoryImpl(movieAPIManager: mockAPIManager, movieRalmManager: mockRealmManager)
        let mockMovieRepository = MockMoviesRepository(dependencies: dependencies)
        return mockMovieRepository
    }()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = MovieViewModel(repository: mockMoviesRepository)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }

    func testInitialization() {
        XCTAssertNotNil(viewModel.repository, "Repository must not be nil on view model.")
    }
    
    func testViewModel_FetchMoviesFromNetwork_ShouldSuceedWithResponse() {
        viewModel.fetchMovies { movies, error in
            guard let movies = movies else {
                XCTFail()
                return
            }
            XCTAssertEqual(movies.count, 2)
        }
    }
    
    func testViewModel_FetchMoviesFromNetwork_ShouldSuceedWithResponseWithPaginationSupport() {
        viewModel.fetchMovies {[weak self] movies, error in
            guard let self = self else { return }
            guard let movies = movies else {
                XCTFail()
                return
            }
            XCTAssertEqual(movies.count, 2)
            XCTAssertEqual(self.viewModel.currentPage, 1)
            XCTAssertEqual(self.viewModel.totalPages, 4)
        }
    }
    
    func testViewModel_FetchMoviesFromLocalStore_ShouldSuceedWithResponse() {
        mockMoviesRepository.isOfflineMode = true
        viewModel.fetchMovies {[weak self] movies, error in
            guard let self = self else { return }
            guard let movies = movies else {
                XCTFail()
                return
            }
            XCTAssertEqual(movies.count, 2)
        }
    }
    
    func testViewModel_FetchFavourites_ShouldReturnValidObjects() {
        viewModel.getFavourites { favourites in
            XCTAssertNotNil(favourites)
            XCTAssertEqual(favourites.count, 1)
        }
    }
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
