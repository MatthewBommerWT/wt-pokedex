//
//  APIClient.swift
//  Pokedex
//
//  Created by Matt Bommer on 2/25/21.
//

import Foundation

enum APIError: Error {
    case missingData
    case parsingFailed
}

class APIClient {

    private var session: URLSession = {
        var config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession(configuration: config)
    }()
    
    
    private func perform(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        print("Is the response cached:", session.configuration.urlCache?.cachedResponse(for: request) != nil)
        print(request.cachePolicy.rawValue)
        let task = session.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
    
    func performDecodable<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        perform(request: request) { data, response, error in
            guard error == nil, let data = data else {
                completion(Result.failure(error ?? APIError.missingData))
                return
            }
            
            do {
                let parsedData = try JSONDecoder().decode(T.self, from: data)
                completion(Result.success(parsedData))
            } catch {
                completion(Result.failure(error))
            }
        }
    }

}
