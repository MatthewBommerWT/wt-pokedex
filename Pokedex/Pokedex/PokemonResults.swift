//
//  PokemonResult.swift
//  PokemonApp
//
//  Created by Matt Kauper on 2/19/21.
//
import Foundation
struct NamedAPIResourceList: Decodable {
    let count: Int
    let next: String
    let previous: String?
    let results: [NamedAPIResource]
}
struct NamedAPIResource: Decodable {
    let name: String
    let url: String
}
struct Pokemon: Decodable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: Sprite
    let types: [Type]
    let abilities: [PokemonAbility]
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case height
        case weight
        case abilities
        case sprites
        case types
    }
}
struct Type: Decodable {
    let typeName: String
    let typeURL: String
    enum CodingKeys: String, CodingKey {
        case type
        case name
        case url
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .type)
        typeName = try typeContainer.decode(String.self, forKey: .name)
        typeURL = try typeContainer.decode(String.self, forKey: .url)
    }
}

struct Sprite: Decodable {
    let thumbnail: String
    let splash: String
    enum CodingKeys: String, CodingKey {
        case thumbnail = "front_default"
        case splash = "official-artwork"
        case other
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        thumbnail = try container.decode(String.self, forKey: .thumbnail)
        let otherContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .other)
        let splashContainer = try otherContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .splash)
        splash = try splashContainer.decode(String.self, forKey: .thumbnail)
    }
}

struct PokemonAbility: Decodable {
    let name: String
    let url: String
    let slot: Int
    let isHidden: Bool
    enum CodingKeys: String, CodingKey {
        case name
        case url
        case slot
        case ability
        case isHidden = "is_hidden"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        slot = try container.decode(Int.self, forKey: .slot)
        isHidden = try container.decode(Bool.self, forKey: .isHidden)
        let abilityContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .ability)
        name = try abilityContainer.decode(String.self, forKey: .name)
        url = try abilityContainer.decode(String.self, forKey: .url)
    }
}
