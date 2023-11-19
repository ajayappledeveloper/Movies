//
//  AppDependencyFactory.swift
//  Movies
//
//  Created by Ajay Babu Singineedi on 17/11/23.
//  Copyright © 2023 ajay Babu. All rights reserved.
//

import Foundation

protocol AppDependencyFactory {
    var movieDependencies: MovieDependencyFactory {get}
}

class AppDependencyFactoryImpl: AppDependencyFactory {
    private(set) var movieDependencies: MovieDependencyFactory
    
    init() {
        movieDependencies = MovieDependencyFactoryImpl(movieAPIManager: MovieAPIManager(), movieRalmManager: RealmMovieManager())
    }
}
