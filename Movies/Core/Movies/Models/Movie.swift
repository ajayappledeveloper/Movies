//
//  Movie.swift
//  Movies
//
//  Created by ajay Babu on 17/11/23.
//  Copyright © 2023 ajay Babu. All rights reserved.
//

import Foundation

struct MoviePaginatedResponse: Codable {
    var page: Int
    var results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    init(page: Int, results: [Movie], totalPages: Int, totalResults: Int) {
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}

struct Movie: Codable {
    let posterPath: String?
    let adult: Bool
    let overview: String
    let id: Int
    let originalTitle: String
    let voteCount: Int
    let voteAverage: Double
    
    var rating: String {
        String(format: "%.1f", voteAverage)
    }
    
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w200\(posterPath)")
    }
}
