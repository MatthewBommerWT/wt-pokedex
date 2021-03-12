//
//  PokemonPromise.swift
//  Pokedex
//
//  Created by Matt Bommer on 3/12/21.
//

import Foundation
import PinkyPromise


class PokemonPromise {
    
    private let client = APIClient()
    private let baseURL = "https://pokeapi.co/api/v2/pokemon"
    private var nextURL: String?
    private var handler: PokemonDataTransfer?
    
    // MARK: Dependecy Injection
    func inject(handler: PokemonDataTransfer) {
        self.handler = handler
    }
    
    // MARK: Promises
    func getRequest() -> URLRequest? {
        var urlComponent = URLComponents(string: nextURL ?? baseURL)
        if nextURL == nil {
            let queries = [URLQueryItem(name: "limit", value: "20"), URLQueryItem(name: "offset", value: "0")]
            urlComponent?.queryItems = queries
        }
        
        guard let url = urlComponent?.url else {
            return nil
        }
        return URLRequest(url: url)
    }
    
    private func fetchPokemonPromise(for resource: NamedAPIResource) -> Promise<Pokemon?>{
        let request = URLRequest(url: URL(string: resource.url)!)
        return client.performPromise(request: request).recover { error -> Promise<Pokemon?> in
            return Promise(value: nil)
        }
    }
    
    private func zipPokemonPromise(resourceList: [NamedAPIResource]) -> Promise<[Pokemon?]> {
        return zipArray(resourceList.map({ resource -> Promise<Pokemon?> in
            fetchPokemonPromise(for: resource)
        }))
    }
    
    func requestPromise() {
        guard let request = getRequest() else {
            return
        }
        
        let pokePromise: Promise<[Pokemon?]> = client.performPromise(request: request)
            .flatMap { (apiResourceList: NamedAPIResourceList) in
                self.nextURL = apiResourceList.next
                return self.zipPokemonPromise(resourceList: apiResourceList.results)
                
            }.onResult { (result: Result<[Pokemon?], Error>) in
                switch result {
                case .success(let listOfPokemon):
                    self.handler?.fillPokemonListAndUpdateCollectionView(filteredPokeList: listOfPokemon.compactMap { $0 })
                case .failure(let error):
                    print(error)
                }
            }
        pokePromise.call()
    }
    
}
