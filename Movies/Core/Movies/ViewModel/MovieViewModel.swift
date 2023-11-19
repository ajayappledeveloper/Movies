//
//  MovieViewModel.swift
//  Movies
//
//  Created by ajay Babu on 17/11/23.
//  Copyright © 2023 ajay Babu. All rights reserved.
//

import Foundation
import RealmSwift

class MovieViewModel {
    private let _repository: MovieRepository
    
    var repository: MovieRepository {
        _repository
    }
    
    var movies: [Movie] {
        guard let movies = repository.movieModel?.results else { return [] }
        return movies
    }
    
    var currentPage: Int? {
        repository.currentPage
    }
    
    var totalPages: Int? {
        repository.totalPages
    }

    init(repository: MovieRepository) {
        self._repository = repository
    }
    
    func fetchMovies(completion: @escaping ([Movie]?, Error?)-> Void) {
        repository.fetchMovies(completion: completion)
    }

    func getFavourites(completion: @escaping ([Movie])-> Void) {
        repository.getFavourites(completion: completion)
    }
    
    func updateFavouriteStatus(for movie: Movie, completion: @escaping (Bool)-> Void) {
        repository.updateFavouriteStatus(for: movie, completion: completion)
    }
    
    func checkFavourite(for title: String, completion: @escaping (Bool)-> Void) {
        repository.checkFavourite(for: title, completion: completion)
    }
}
