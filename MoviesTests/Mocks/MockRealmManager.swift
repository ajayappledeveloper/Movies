//
//  MockRealmManager.swift
//  MoviesTests
//
//  Created by Ajay Babu Singineedi on 19/11/23.
//  Copyright © 2023 ajay Babu. All rights reserved.
//

import Foundation
import RealmSwift
@testable import Movies

class MockRealmManager: MovieRealmService {
    var realmQueue: DispatchQueue = DispatchQueue.global(qos: .utility)
    
    func add(movieRlm: MovieRealm) {
        
    }
    
    func fetchMovies(completion: @escaping (RealmSwift.Results<MovieRealm>) -> Void) {
        
    }
    
    func updateFavouriteStatus(for movie: Movie, completion: @escaping (Bool) -> Void) {
        
    }
    
    func getFavourites(completion: @escaping ([Movie]) -> Void) {
        
    }
    
    func checkFavourite(for title: String, completion: @escaping (Bool) -> Void) {
        
    }
}
