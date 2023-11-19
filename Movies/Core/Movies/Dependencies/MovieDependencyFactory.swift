//
//  MovieDependencyFactory.swift
//  Movies
//
//  Created by Ajay Babu Singineedi on 17/11/23.
//  Copyright © 2023 ajay Babu. All rights reserved.
//

import Foundation

protocol MovieDependencyFactory {
    var movieAPIManager: MovieAPIService {get}
    var movieRealmManager: MovieRealmService {get}
}

class MovieDependencyFactoryImpl: MovieDependencyFactory {
    private(set) var movieAPIManager: MovieAPIService
    private(set) var movieRealmManager: MovieRealmService
    
    init(movieAPIManager: MovieAPIService, movieRalmManager: MovieRealmService) {
        self.movieAPIManager = movieAPIManager
        self.movieRealmManager = movieRalmManager
    }
}
