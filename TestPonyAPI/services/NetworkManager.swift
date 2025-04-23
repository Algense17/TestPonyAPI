//
//  NetworkManager.swift
//  TestPonyAPI
//
//  Created by Vasiliy on 15.04.2025.
//

import Foundation
import UIKit

enum Link {
    case allPony
    
    var url: URL {
        switch self {
        case .allPony:
            URL(string: "https://ponyapi.net/v1/character/all")!
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case httpError(Int)
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession(configuration: config)
    }()
    
    private init() {
        configureURLCache()
    }
    
    func fetchData(from url: URL, completion: @escaping(Result<[Character], NetworkError>) -> Void) {
        session.dataTask(with: url) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                completion(.failure(.httpError(httpResponse.statusCode)))
                return
            }
                
            guard let data else {
                print(error?.localizedDescription ?? "No error description")
                completion(.failure(.noData))
                return
            }
            
            do {
                let ponyCharacters = try JSONDecoder().decode(Pony.self, from: data)
                ponyCharacters.data.forEach{print($0)}
                DispatchQueue.main.async {
                    completion(.success(ponyCharacters.data))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func fetchImage(from url: URL, completion: @escaping(Result<Data, NetworkError>) -> Void) -> URLSessionTask {
         let dataTask = session.dataTask(with: url) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                completion(.failure(.httpError(httpResponse.statusCode)))
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No error description")
                return
            }
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }
        
        dataTask.resume()
        return dataTask
    }
    
    private func configureURLCache() {
        let memoryCapacity = 50 * 1024 * 1024 // 50 MB
        let diskCapacity = 100 * 1024 * 1024 // 100 MB
        
        let cache = URLCache(
            memoryCapacity: memoryCapacity,
            diskCapacity: diskCapacity,
            diskPath: "urlCache"
        )
        
        URLCache.shared = cache
    }
}

final class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
}
