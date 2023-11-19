//
//  MovieRepository.swift
//  Movies
//
//  Created by Ajay Babu Singineedi on 16/11/23.
//  Copyright © 2023 ajay Babu. All rights reserved.
//

import Foundation
import RealmSwift

protocol MovieRepository {
    var movieModel: MoviePaginatedResponse? {get}
    var currentPage: Int? {get}
    var totalPages: Int? {get}
    
    var dependencies: MovieDependencyFactory {get}
    
    func fetchMovies(completion: @escaping ([Movie]?, Error?)-> Void)
    func fetchMovieDetails(for id: Int, completion: @escaping (Result<MovieDetail, NetworkError>)-> Void)
    func getFavourites(completion: @escaping ([Movie])-> Void)
    func updateFavouriteStatus(for movie: Movie, completion: @escaping (Bool)-> Void)
    func checkFavourite(for title: String, completion: @escaping (Bool)-> Void)
}

class MovieRepositoryImpl: MovieRepository {
   
    var dependencies: MovieDependencyFactory
    
    var movieAPIManager: MovieAPIService {
        dependencies.movieAPIManager
    }
   
    private var realmManager: MovieRealmService {
        dependencies.movieRealmManager
    }
    
    var movieModel: MoviePaginatedResponse?
    private var rechability: Reachability = try! Reachability()
    
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
    
    init(dependencies: MovieDependencyFactory) {
        self.dependencies = dependencies
    }
    
    /// Checks the network connection and performs the fectching. If network is avilable, gets the results from the TMDB API with pagination and caches in Realm. When connection is offline, fetches the results from the local realm store.
    /// - Parameter completion: call back handler that passe's fetched movies.
    func fetchMovies(completion: @escaping ([Movie]?, Error?)-> Void) {
        //Retch results from Realm Store.
        if(rechability.connection == .unavailable) {
            realmManager.fetchMovies { rlmMovies in
                let movies: [Movie] = rlmMovies.elements.map { (rlmMovie) -> Movie in
                    return Movie(posterPath: rlmMovie.posterPath, adult: rlmMovie.adult, overview: rlmMovie.overview, id: rlmMovie.id ?? 0, originalTitle: rlmMovie.originalTitle ?? "", voteCount: rlmMovie.voteCount ?? 0, voteAverage: rlmMovie.voteAverage)
                }
                self.movieModel = MoviePaginatedResponse(page: 1, results: movies, totalPages: 1, totalResults: movies.count)
                completion(self.movieModel!.results, nil)
            }
        } else {
            //Fetech results from TMDB API
            movieAPIManager.fetchMovies(nextPage: nextPage) { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success(let model):
                    print("Fetched results of page \(self.nextPage)")
                    if let movieModel = self.movieModel, movieModel.page >= 1 {
                        self.movieModel?.page = model.page
                        self.movieModel?.results.append(contentsOf: model.results)
                    } else {
                        self.movieModel = model
                    }
                    completion(self.movieModel?.results, nil)
                    
                    let moviesRlm:[MovieRealm] = model.results.map { (movie) -> MovieRealm in
                        return MovieRealm.fromMovie(movie: movie)
                    }
                    for movieRlm in moviesRlm {
                        self.realmManager.add(movieRlm: movieRlm)
                    }
                case .failure(let error):
                    completion(nil, error)
                }
            }
            
        }
    }
    
    func fetchMovieDetails(for id: Int, completion: @escaping (Result<MovieDetail, NetworkError>)-> Void)  {
        if rechability.connection == .unavailable {
            completion(.failure(.offline))
        } else {
            movieAPIManager.fetchMovieDetails(for: id, completion: completion)
        }
    }
    
    /// Filters the favourite movies from the Realm Store and apply transfromation on Realm instances for the caller.
    /// - Parameter completion: call back handler that pass the favourite movies.
    func getFavourites(completion: @escaping ([Movie])-> Void) {
        realmManager.getFavourites(completion: completion)
    }
    
    func updateFavouriteStatus(for movie: Movie, completion: @escaping (Bool)-> Void) {
        realmManager.updateFavouriteStatus(for: movie, completion: completion)
    }
    
    /// Checks if a given movie is favorited by user in the local Realm Store.
    /// - Parameters:
    ///   - title: Movie title that needs to be checked for favourited or not.
    ///   - completion: call back handler that pass a boolean to indicate favourited or not to the caller.
    func checkFavourite(for title: String, completion: @escaping (Bool)-> Void) {
        realmManager.checkFavourite(for: title, completion: completion)
    }
}
