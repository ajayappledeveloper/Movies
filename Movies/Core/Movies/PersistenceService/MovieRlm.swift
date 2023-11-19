//
//  MovieRlm.swift
//  Movies
//
//  Created by ajay Babu on 17/11/23.
//  Copyright © 2023 ajay Babu. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class MovieRealm: Object {
    @Persisted var id: Int? = nil
    @Persisted var posterPath: String? = nil
    @Persisted var adult: Bool = false
    @Persisted var overview: String = ""
    @Persisted var originalTitle: String? = nil
    @Persisted var voteCount: Int? = nil
    @Persisted var voteAverage: Double = 0.0
    @Persisted var isFavourite: Bool = false
    
    convenience init(id: Int, posterPath: String, adult: Bool, overview: String, originalTitle: String, voteCount: Int, voteAvg: Double) {
        self.init()
        self.id = id
        self.posterPath = posterPath
        self.adult = adult
        self.overview = overview
        self.originalTitle = originalTitle
        self.voteCount = voteCount
        self.voteAverage = voteAvg
        
    }
    
    static func fromMovie(movie: Movie) -> MovieRealm {
        let movieRlm: MovieRealm = MovieRealm()
        movieRlm.id = movie.id
        movieRlm.posterPath = movie.posterPath
        movieRlm.adult = movie.adult
        movieRlm.overview = movie.overview
        movieRlm.originalTitle = movie.originalTitle
        movieRlm.voteCount = movie.voteCount
        movieRlm.voteAverage = movie.voteAverage
        return movieRlm
    }
}

