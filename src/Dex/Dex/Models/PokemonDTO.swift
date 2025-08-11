// //
// //  PokemonDTO.swift
// //  Dex
// //
// //  Created by Reinier Garcia on 8/11/25.
// //
//
import Foundation

struct PokemonDTO: Decodable {
    let id: Int16
    let name: String
    let types: [TypeEntry]
    let stats: [StatEntry]
    let sprites: Sprites

    struct Name: Decodable { let name: String }
    struct TypeEntry: Decodable { let type: Name }
    struct StatEntry: Decodable {
        let baseStat: Int16
        let stat: Name
        enum CodingKeys: String, CodingKey { case baseStat = "base_stat", stat }
    }

    struct Sprites: Decodable {
        let frontDefault: URL
        let frontShiny: URL
        enum CodingKeys: String, CodingKey { case frontDefault = "front_default", frontShiny = "front_shiny" }
    }

    var typeNames: [String] { types.map { $0.type.name } }

    // Name-based (robust even if order changes)
    private func stat(_ key: String) -> Int16 {
        stats.first(where: { $0.stat.name == key })?.baseStat ?? 0
    }

    var hp: Int16 { stat("hp") }
    var attack: Int16 { stat("attack") }
    var defense: Int16 { stat("defense") }
    var specialAttack: Int16 { stat("special-attack") }
    var specialDefense: Int16 { stat("special-defense") }
    var speed: Int16 { stat("speed") }

    var sprite: URL { sprites.frontDefault }
    var shiny: URL { sprites.frontShiny }
}
