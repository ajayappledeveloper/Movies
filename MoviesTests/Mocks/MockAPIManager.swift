//
//  MockAPIManager.swift
//  MoviesTests
//
//  Created by Ajay Babu Singineedi on 19/11/23.
//  Copyright © 2023 ajay Babu. All rights reserved.
//

import Foundation
@testable import Movies

class MockAPIManager: MovieAPIService {
    func fetchMovies(nextPage: Int, completion: @escaping (Result<MoviePaginatedResponse, NetworkError>) -> Void) {
        guard let model: MoviePaginatedResponse = MockJsonFileLoader.fetchData(fileName: "MockMovies", type: MoviePaginatedResponse.self) else {
            completion(.failure(.badResponse))
            return
        }
        completion(.success(model))
    }
    
    func fetchMovieDetails(for id: Int, completion: @escaping (Result<MovieDetail, NetworkError>) -> Void) {
        guard let model: MovieDetail = MockJsonFileLoader.fetchData(fileName: "MockMovieDetail", type: MovieDetail.self) else {
            completion(.failure(.badResponse))
            return
        }
        completion(.success(model))
    }
}
