//
//  MovieHttpService.swift
//  Movies
//
//  Created by Ajay Babu Singineedi on 16/11/23.
//  Copyright © 2023 ajay Babu. All rights reserved.
//

import Foundation

protocol MovieAPIService {
    func fetchMovies(nextPage: Int, completion: @escaping (Result<MoviePaginatedResponse, NetworkError>)-> Void)
    func fetchMovieDetails(for id: Int, completion: @escaping (Result<MovieDetail, NetworkError>)-> Void)
}

enum MovieEndPonits {
    static let baseURL: String = "https://api.themoviedb.org/3/movie"
    static let APIKey: String = "34c902e6393dc8d970be5340928602a7"
    static let movies = "now_playing"
    
    static func getMoviesURL(nextPage: Int) -> String {
        let queryItems = [
            URLQueryItem(name: "api_key", value: APIKey),
            URLQueryItem(name: "page", value: "\(nextPage)")
        ]
        var urlComponents = URLComponents(string: "\(baseURL)/\(movies)")
        urlComponents?.queryItems = queryItems
        guard let finalURLString = urlComponents?.url?.absoluteString else { return "" }
        return finalURLString
    }
    
    static func getMovieDetailURL(id: Int) -> String {
        let queryItems = [
            URLQueryItem(name: "api_key", value: APIKey),
        ]
        var urlComponents = URLComponents(string: String(format: "\(baseURL)/%d", id))
        urlComponents?.queryItems = queryItems
        guard let finalURLString = urlComponents?.url?.absoluteString else { return "" }
        return finalURLString
    }
}

class MovieAPIManager: MovieAPIService {

    func fetchMovies(nextPage: Int, completion: @escaping (Result<MoviePaginatedResponse, NetworkError>)-> Void) {
        let urlString =  MovieEndPonits.getMoviesURL(nextPage: nextPage)
        NetworkManager.shared.fetchData(from: urlString, type: MoviePaginatedResponse.self, completion: completion)
    }
    
    func fetchMovieDetails(for id: Int, completion: @escaping (Result<MovieDetail, NetworkError>)-> Void) {
        let urlString = MovieEndPonits.getMovieDetailURL(id: id)
        NetworkManager.shared.fetchData(from: urlString, type: MovieDetail.self, completion: completion)
    }
}

