//
//  MockMoviesRepository.swift
//  MoviesTests
//
//  Created by Ajay Babu Singineedi on 19/11/23.
//  Copyright © 2023 ajay Babu. All rights reserved.
//

import Foundation
@testable import Movies

class MockMoviesRepository: MovieRepository {
    var movieModel: MoviePaginatedResponse?
    
    var movies: [Movie] {
        guard let movieModel = movieModel else { return [] }
        return movieModel.results
    }
    
    var currentPage: Int? {
        guard let movieModel = movieModel else { return nil }
        return movieModel.page
    }
    var totalPages: Int? {
        guard let movieModel = movieModel else { return nil }
        return movieModel.totalPages
    }
    
    var nextPage: Int {
        var page = 1
        if let movieModel = movieModel, let currentPage = self.currentPage, movieModel.page >= 1 {
            page = currentPage + 1
        }
        return page
    }
    
    var dependencies: Movies.MovieDependencyFactory
    
    var mockApiManager: MovieAPIService {
        dependencies.movieAPIManager
    }
    
    var mockRealmManager: MovieRealmService {
        dependencies.movieRealmManager
    }
    
    var isOfflineMode: Bool = false
    
    init(dependencies: MovieDependencyFactory) {
        self.dependencies = dependencies
    }
    
    func fetchMovies(completion: @escaping ([Movie]?, Error?) -> Void) {
        if isOfflineMode {
            let movies = [Movie(posterPath: "/A4j8S6moJS2zNtRR8oWF08gRnL5.jpg", adult: false, overview: "", id: 1, originalTitle: "Five Nights at Freddy's", voteCount: 8, voteAverage: 8), Movie(posterPath: "/iwsMu0ehRPbtaSxqiaUDQB9qMWT.jpg", adult: false, overview: "", id: 2, originalTitle: "Expend4bles", voteCount: 9, voteAverage: 9)]
            completion(movies, nil)
        } else {
            mockApiManager.fetchMovies(nextPage: nextPage) { result in
                switch result {
                case .success(let model):
                    self.movieModel = model
                    completion(model.results, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
    
    func fetchMovieDetails(for id: Int, completion: @escaping (Result<MovieDetail, NetworkError>) -> Void) {
        mockApiManager.fetchMovieDetails(for: id, completion: completion)
    }
    
    func getFavourites(completion: @escaping ([Movie]) -> Void) {
        let favourites = [Movie(posterPath: "/A4j8S6moJS2zNtRR8oWF08gRnL5.jpg", adult: false, overview: "", id: 1, originalTitle: "Five Nights at Freddy's", voteCount: 8, voteAverage: 8)]
        completion(favourites)
    }
    
    func updateFavouriteStatus(for movie: Movie, completion: @escaping (Bool) -> Void) {
        
    }
    
    func checkFavourite(for title: String, completion: @escaping (Bool) -> Void) {
        
    }
    
    
}
