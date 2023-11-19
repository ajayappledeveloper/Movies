//
//  MockJsonFileLoader.swift
//  MoviesTests
//
//  Created by Ajay Babu Singineedi on 19/11/23.
//  Copyright © 2023 ajay Babu. All rights reserved.
//

import Foundation

class MockJsonFileLoader {
    
    static func fetchData<T: Codable>(fileName: String, type:T.Type) -> T? {
        let bundle = Bundle.init(for: MockJsonFileLoader.self)
        guard let fileURL = bundle.url(forResource: fileName, withExtension: "json") else {return nil}
        
        guard let data = try? Data(contentsOf: fileURL) else { return nil}
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return try? jsonDecoder.decode(type.self, from: data)
    }
}
