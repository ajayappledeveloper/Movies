//
//  MoviewDatail.swift
//  Movies
//
//  Created by Ajay Babu Singineedi on 17/11/23.
//  Copyright © 2023 ajay Babu. All rights reserved.
//

import Foundation

struct MovieDetail: Codable {
    let adult: Bool
    let backdropPath: String?
    let budget: Int
    let genres: [Genre]
    let homepage: String?
    let id: Int
    let imdbId: String?
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let status: String
    let tagline: String?
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w300\(posterPath)")
    }
    
    var genre: String {
        return genres.map{ $0.name }.joined(separator: ", ")
    }
    
    var rating: String {
        String(format: "%.1f", voteAverage)
    }
}

struct Genre: Codable {
    let id: Int
    let name: String
}
