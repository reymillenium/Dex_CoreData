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

    convenience init(context: NSManagedObjectContext, from fetched: FetchedPokemon, favorite: Bool = false) {
        self.init(context: context)
        self.id = fetched.id
        self.name = fetched.name
        self.types = fetched.types
        self.hp = fetched.hp
        self.attack = fetched.attack
        self.defense = fetched.defense
        self.specialAttack = fetched.specialAttack
        self.specialDefense = fetched.specialDefense
        self.speed = fetched.speed
        self.sprite = fetched.sprite
        self.shiny = fetched.shiny
        self.favorite = favorite
    }

    // Handy updater for existing rows (e.g., on refresh):
    func apply(_ fetched: FetchedPokemon, favorite: Bool? = nil) {
        name = fetched.name
        types = fetched.types
        hp = fetched.hp
        attack = fetched.attack
        defense = fetched.defense
        specialAttack = fetched.specialAttack
        specialDefense = fetched.specialDefense
        speed = fetched.speed
        sprite = fetched.sprite
        shiny = fetched.shiny
        if let favorite { self.favorite = favorite }
    }
}
