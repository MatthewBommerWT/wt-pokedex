//
//  APIClient.swift
//  Pokedex
//
//  Created by Matt Bommer on 2/25/21.
//

import Foundation
import Combine
import PinkyPromise

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
    
    private let baseURL: String = "https://pokeapi.co/api/v2/pokemon"
    private var currentURL: URL?
    
    private func buildInitialURLIfNecessary() {
        guard currentURL == nil else { return }
        var urlComponent = URLComponents(string: baseURL)
        let queries = [URLQueryItem(name: "limit", value: "20"), URLQueryItem(name: "offset", value: "0")]
        urlComponent?.queryItems = queries
        currentURL = urlComponent?.url
    }
    
    private func buildResourceListRequest() -> URLRequest {
        buildInitialURLIfNecessary()
        return URLRequest(url: currentURL!)
    }
    
    /// The Combine way of handing network calls and distributing data
    func collectPokemon() -> AnyPublisher<[Pokemon], Error> {
        buildInitialURLIfNecessary()
        let publisher = URLSession.shared.dataTaskPublisher(for: currentURL!)
            .map(\.data)
            .decode(
                type: NamedAPIResourceList.self,
                decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .flatMap({ (resourceList) -> AnyPublisher<Pokemon, Error> in
                self.currentURL = URL(string: resourceList.next)
                return Publishers.MergeMany (
                    resourceList.results
                        .compactMap { URL(string: $0.url) }
                        .map(self.fetchPokemon)
                )
                .eraseToAnyPublisher()
            })
            .collect()
            .eraseToAnyPublisher()
        return publisher
    }
    
    private func fetchPokemon(url: URL) -> AnyPublisher<Pokemon, Error> {
        return Deferred {
            URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .decode(
                    type: Pokemon.self,
                    decoder: JSONDecoder()
                )
        }.eraseToAnyPublisher()
    }
    
    /// The Promise way of handling network calls and distributing data
    private func perform(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
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

    private func performPromise<T: Decodable>(request: URLRequest? = nil) -> Promise<T> {
        return Promise { fulfill in
            self.performDecodable(request: request ?? self.buildResourceListRequest()) { (result: Result<T, Error>) in
                fulfill(result)
            }
        }
    }
    
    // MARK: Promises
    private func fetchPokemonPromise(for resource: NamedAPIResource) -> Promise<Pokemon?> {
        let request = URLRequest(url: URL(string: resource.url)!)
        return performPromise(request: request).recover { error -> Promise<Pokemon?> in
            return Promise(value: nil)
        }
    }
    
    private func zipPokemonPromise(resourceList: [NamedAPIResource]) -> Promise<[Pokemon?]> {
        return zipArray(resourceList.map({ resource -> Promise<Pokemon?> in
            fetchPokemonPromise(for: resource)
        }))
    }
    
    
    func fetchPokemon() -> Promise<[Pokemon?]> {
        return performPromise()
            .flatMap { (apiResourceList: NamedAPIResourceList) in
                self.currentURL = URL(string: apiResourceList.next)
                return self.zipPokemonPromise(resourceList: apiResourceList.results)
            }
    }
}
