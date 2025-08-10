//
//  PokemonExtensions.swift
//  Dex
//
//  Created by Reinier Garcia on 8/9/25.
//

import CoreData
import Foundation

// MARK: - Convenience initializer

extension Pokemon {
    convenience init(
        context: NSManagedObjectContext,
        id: Int16,
        name: String,
        types: [String],
        hp: Int16, attack: Int16, defense: Int16,
        specialAttack: Int16, specialDefense: Int16, speed: Int16,
        sprite: URL, shiny: URL, favorite: Bool = false
    ) {
        self.init(context: context)
        self.id = id
        self.name = name
        self.types = types
        self.hp = hp
        self.attack = attack
        self.defense = defense
        self.specialAttack = specialAttack
        self.specialDefense = specialDefense
        self.speed = speed
        self.sprite = sprite
        self.shiny = shiny
        self.favorite = favorite
    }
}
