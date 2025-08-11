//
//  FetchedPokemon.swift
//  Dex
//
//  Created by Reinier Garcia on 8/11/25.
//

import Foundation

struct FetchedPokemon: Decodable {
    let id: Int16
    let name: String
    let types: [String]
    let hp: Int16
    let attack: Int16
    let defense: Int16
    let specialAttack: Int16
    let specialDefense: Int16
    let speed: Int16
    let sprite: URL
    let shiny: URL

    enum CodingKeys: CodingKey {
        case id
        case name
        case types
        case stats
        case sprites
        
        enum TypeDictionaryKeys: CodingKey {
            case type
            
            enum TypeKeys: CodingKey {
                case name
            }
        }
        
        enum StatDictionaryKeys: CodingKey {
            case baseStat
        }
        
        enum SpriteKeys: String, CodingKey {
            case sprite = "frontDefault"
            case shiny = "frontShiny"
        }
    }

    init(from decoder: any Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try rootContainer.decode(Int16.self, forKey: .id)
        self.name = try rootContainer.decode(String.self, forKey: .name)
               
        var decodedTypes: [String] = []
        var typesContainer = try rootContainer.nestedUnkeyedContainer(forKey: .types) // An Array (Unkeyed container)
        while !typesContainer.isAtEnd {
            let typesDictionaryContainer = try typesContainer.nestedContainer(keyedBy: CodingKeys.TypeDictionaryKeys.self)
            let typeContainer = try typesDictionaryContainer.nestedContainer(keyedBy: CodingKeys.TypeDictionaryKeys.TypeKeys.self, forKey: .type)
            let type = try typeContainer.decode(String.self, forKey: .name)
            decodedTypes.append(type)
        }
        self.types = decodedTypes
        
        var decodedStats: [Int16] = []
        var statsContainer = try rootContainer.nestedUnkeyedContainer(forKey: .stats) // An Array (Unkeyed container)
        while !statsContainer.isAtEnd {
            let statsDictionaryContainer = try statsContainer.nestedContainer(keyedBy: CodingKeys.StatDictionaryKeys.self)
            let stat = try statsDictionaryContainer.decode(Int16.self, forKey: .baseStat)
            decodedStats.append(stat)
        }
        self.hp = decodedStats[0]
        self.attack = decodedStats[1]
        self.defense = decodedStats[2]
        self.specialAttack = decodedStats[3]
        self.specialDefense = decodedStats[4]
        self.speed = decodedStats[5]
        
        let spriteContainer = try rootContainer.nestedContainer(keyedBy: CodingKeys.SpriteKeys.self, forKey: .sprites)
        self.sprite = try spriteContainer.decode(URL.self, forKey: .sprite)
        self.shiny = try spriteContainer.decode(URL.self, forKey: .shiny)
    }
}
