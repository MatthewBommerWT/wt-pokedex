////
////  PokePublisher.swift
////  Pokedex
////
////  Created by Matt Bommer on 11/8/21.
////
//
//import Foundation
//import Combine
//import UIKit
//
//class PokemonSubscription<S: Subscriber>: Subscription where S.Input == Data, S.Failure == Error {
//    
//    private let urlSession = URLSession.shared
//    private var urlRequest: URLRequest
//    private var subscriber: S?
//    
//    init(request: URLRequest, subscriber: S) {
//        self.urlRequest = request
//        self.subscriber = subscriber
//        sendRequest()
//    }
//    
//    private func sendRequest() {
//        guard let sub = subscriber else { return }
//        urlSession.dataTask(with: urlRequest) { (data, _, error) in
//            _ = data.map(sub.receive)
//            _ = error.map { sub.receive(completion: Subscribers.Completion.failure($0))}
//        }.resume()
//    }
//    
//    func request(_ demand: Subscribers.Demand) {
//        guard let demandedAmount = demand.max else { return }
//        for _ in (0..<demandedAmount) {
//            sendRequest()
//        }
//    }
//    
//    func cancel() {
//        subscriber = nil
//    }
//    
//}
//
//struct PokePublisher: Publisher {
//    
//    typealias Output = Data
//    typealias Failure = Error
//    
//    private let urlRequest: URLRequest
//    
//    init(urlRequest: URLRequest) {
//        self.urlRequest = urlRequest
//    }
//    
//    func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
//        let subscription = PokemonSubscription(request: self.urlRequest, subscriber: subscriber)
//        subscriber.receive(subscription: subscription)
//    }
//    
//}
//
//struct PokeSubscriber: Subscriber {
//    
//    typealias Input = Data
//    typealias Failure = Error
//
//    var combineIdentifier: CombineIdentifier
//    
//    func receive(subscription: Subscription) {
//        subscription.request(.unlimited)
//    }
//    
//    func receive(_ input: Data) -> Subscribers.Demand {
//        return .none
//    }
//    
//    func receive(completion: Subscribers.Completion<Error>) {
//        <#code#>
//    }
//    
//}
