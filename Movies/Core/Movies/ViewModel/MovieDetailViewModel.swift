//
//  MovieDetailViewModel.swift
//  Movies
//
//  Created by Ajay Babu Singineedi on 18/11/23.
//  Copyright © 2023 ajay Babu. All rights reserved.
//

import Foundation

class MovieDetailViewModel {
    
    private let _repository: MovieRepository
    private(set) var movieDetail: MovieDetail?
    let id: Int
    
    var repository: MovieRepository {
        return _repository
    }
    
    var posterURL: URL? {
        movieDetail?.posterURL
    }
    
    var title: String? {
        "\(movieDetail?.title ?? "")\n\(movieDetail?.tagline ?? "")"
    }
    
    var genre: String? {
        "Genres: \(movieDetail?.genre ?? "NA")"
    }
    
    var info: String {
        var detail = "Adult: "
        guard let model = movieDetail else { return "" }
        detail += model.adult ? "Yes" : "No"
    
        detail += " "
        detail += "Rating: \(model.rating)"
        return detail
    }
    
    var synopsis: String? {
        "Synopsis: \(movieDetail?.overview ?? "")"
    }
    
    var errorMessage: String?
    
    init(repository: MovieRepository, id: Int) {
        self._repository = repository
        self.id = id
    }
    
    func fetchMovieDetails(for id: Int, completion: @escaping (Bool)-> Void) {
        repository.fetchMovieDetails(for: id) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movieDetail):
                self.movieDetail = movieDetail
                completion(true)
            case .failure(let error):
                switch error {
                case .offline:
                    self.errorMessage = "Offline"
                    default:
                    self.errorMessage = error.localizedDescription
                }
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
}
