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
struct Pokemon: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: Sprite
    let types: [PokeType]
    let stats: [PokeStat]
    let abilities: [PokemonAbility]
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case height
        case weight
        case abilities
        case sprites
        case types
        case stats
    }
}

struct PokeStat: Codable {
    let statName: String
    let baseValue: Int
    enum CodingKeys: String, CodingKey {
        case stat
        case name
        case base = "base_stat"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        baseValue = try container.decode(Int.self, forKey: .base)
        let nameContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .stat)
        statName = try nameContainer.decode(String.self, forKey: .name)
    }
    func encode(to encode: Encoder) throws {
        var container = encode.container(keyedBy: CodingKeys.self)
        try container.encode(baseValue, forKey: .base)
        var nameContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .stat)
        try nameContainer.encode(statName, forKey: .name)
    }
}

struct PokeType: Codable {
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
    func encode(to encode: Encoder) throws {
        var container = encode.container(keyedBy: CodingKeys.self)
        var typeContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .type)
        try typeContainer.encode(typeName, forKey: .name)
        try typeContainer.encode(typeURL, forKey: .url)
    }
}

struct Sprite: Codable {
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
    func encode(to encode: Encoder) throws {
        var container = encode.container(keyedBy: CodingKeys.self)
        try container.encode(thumbnail, forKey: .thumbnail)
        var otherContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .other)
        var splashContainer = otherContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .splash)
        try splashContainer.encode(splash, forKey: .thumbnail)
    }
}

struct PokemonAbility: Codable {
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
    
    func encode(to encode: Encoder) throws {
        var container = encode.container(keyedBy: CodingKeys.self)
        try container.encode(slot, forKey: .slot)
        try container.encode(isHidden, forKey: .isHidden)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .ability)
        try nested.encode(name, forKey: .name)
        try nested.encode(url, forKey: .url)
    }
}
