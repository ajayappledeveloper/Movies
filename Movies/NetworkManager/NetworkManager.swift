//
//  NetworkManager.swift
//  Movies
//
//  Created by ajay Babu on 17/11/23.
//  Copyright © 2023 ajay Babu. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case badResponse
    case decodingError(message: String)
    case offline
}

final class NetworkManager {
   
    static let shared = NetworkManager()
    let session = URLSession.shared
    
    private init(){}
    
    func fetchData<T: Codable>(from url: String, type: T.Type, completion: @escaping(Result<T,NetworkError>)-> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.badURL))
            return
        }
        session.dataTask(with: url) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                guard let data = data else {
                    completion(.failure(.badResponse))
                    return
                }
                let decoder: JSONDecoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let model = try decoder.decode(T.self, from: data)
                    completion(.success(model))
                } catch let error as DecodingError {
                    completion(.failure(.decodingError(message: error.localizedDescription)))
                } catch {
                    print(error)
                }
                
            } else {
                completion(.failure(.badResponse))
            }
        }.resume()
    }
 
}
