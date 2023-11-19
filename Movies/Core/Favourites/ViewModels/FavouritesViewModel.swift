//
//  FavouritesViewModel.swift
//  Movies
//
//  Created by Ajay Babu Singineedi on 17/11/23.
//  Copyright © 2023 ajay Babu. All rights reserved.
//

import Foundation

class FavouritesViewModel {
    private let repository: MovieRepository
    
    private(set) var favourites: [Movie] = []
    
    init(repository: MovieRepository) {
        self.repository = repository
    }
    
    func getFavourites(completion: @escaping () -> Void) {
        repository.getFavourites { favourites in
            self.favourites = favourites
            completion()
        }
    }
    
}
