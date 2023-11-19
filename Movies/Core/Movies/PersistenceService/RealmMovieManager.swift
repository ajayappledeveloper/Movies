//
//  RealmMovieManager.swift
//  Movies
//
//  Created by Ajay Babu Singineedi on 17/11/23.
//  Copyright © 2023 ajay Babu. All rights reserved.
//

import Foundation
import RealmSwift

protocol MovieRealmService {
    var realmQueue: DispatchQueue {get}
    func add(movieRlm: MovieRealm)
    func fetchMovies(completion: @escaping (Results<MovieRealm>)-> Void)
    func updateFavouriteStatus(for movie: Movie, completion: @escaping (Bool)-> Void)
    func getFavourites(completion: @escaping ([Movie])-> Void)
    func checkFavourite(for title: String, completion: @escaping (Bool)-> Void)
}

class RealmMovieManager: MovieRealmService {
    
    var realmQueue = DispatchQueue.global(qos: .utility)

    static let shared: RealmMovieManager = RealmMovieManager()
    
    func add(movieRlm: MovieRealm) {
        realmQueue.async {
            do {
                let manager: Realm = try Realm()
                try manager.write {
                    let results: Results<MovieRealm> = manager.objects(MovieRealm.self).filter("originalTitle = %@", movieRlm.originalTitle ?? "")
                    if(results.isEmpty) {
                        manager.add(movieRlm)
                    }
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    func fetchMovies(completion: @escaping (Results<MovieRealm>)-> Void) {
        realmQueue.async {
            let manager: Realm = try! Realm()
            let moviesRlm: Results<MovieRealm> = manager.objects(MovieRealm.self)
            completion(moviesRlm)
        }
    }
    
    func updateFavouriteStatus(for movie: Movie, completion: @escaping (Bool)-> Void) {
        realmQueue.async {
            let manager: Realm = try! Realm()
            let rlmMovie:Results<MovieRealm> = manager.objects(MovieRealm.self).filter("originalTitle = %@", movie.originalTitle)
            if rlmMovie.count > 0 {
                guard let object = rlmMovie.first else {return}
                do {
                    let manager: Realm = try Realm()
                    try manager.write {
                        object.isFavourite = !object.isFavourite
                        completion(true)
                    }
                } catch let error {
                    print(error)
                    completion(false)
                }

            }
        }
    }
    
    /// Filters the favourite movies from the Realm Store and apply transfromation on Realm instances for the caller.
    /// - Parameter completion: call back handler that pass the favourite movies.
    func getFavourites(completion: @escaping ([Movie])-> Void) {
        self.realmQueue.async {
            let manager: Realm = try! Realm()
            let favouritesRlm: [MovieRealm] = manager.objects(MovieRealm.self).filter { (movie) -> Bool in
                return (movie.isFavourite == true)
            }
            
            let favourites: [Movie] =  favouritesRlm.map { (rlmMovie) -> Movie in
                return Movie(posterPath: rlmMovie.posterPath ?? "", adult: rlmMovie.adult, overview: rlmMovie.overview, id: rlmMovie.id ?? 0, originalTitle: rlmMovie.originalTitle ?? "", voteCount: rlmMovie.voteCount ?? 0, voteAverage: rlmMovie.voteAverage)
            }
            completion(favourites)
        }
    }
    
    /// Checks if a given movie is favorited by user in the local Realm Store.
    /// - Parameters:
    ///   - title: Movie title that needs to be checked for favourited or not.
    ///   - completion: call back handler that pass a boolean to indicate favourited or not to the caller.
    func checkFavourite(for title: String, completion: @escaping (Bool)-> Void) {
        realmQueue.async {
            let manager: Realm = try! Realm()
            let rlmMovies:Results<MovieRealm> = manager.objects(MovieRealm.self).filter("originalTitle = %@", title)
            if rlmMovies.count > 0 {
                guard let first = rlmMovies.first else {return}
                completion(first.isFavourite)
                return
            }
            completion(false)
        }
    }
}
