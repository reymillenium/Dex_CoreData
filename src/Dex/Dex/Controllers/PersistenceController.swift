//
//  Persistence.swift
//  Dex
//
//  Created by Reinier Garcia on 8/8/25.
//

import CoreData

struct PersistenceController {
    // The thing that controls our real database
    static let shared = PersistenceController()

    // The thing that controls our sample preview database
    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for index in 0 ..< 10 {
            let newPokemon = Pokemon(context: viewContext)

            let pokemonId = Int16(index) + 1
            newPokemon.id = pokemonId
            newPokemon.name = "Pokémon \(pokemonId)"
            newPokemon.types = ["normal"] // no cast

            // Example stats (dummy values)
            newPokemon.hp = 50
            newPokemon.attack = 55
            newPokemon.defense = 45
            newPokemon.specialAttack = 60
            newPokemon.specialDefense = 50
            newPokemon.speed = 65

            // Example URLs (replace with real sprite links)
            newPokemon.sprite = URL(string: "https://example.com/sprite\(pokemonId).png")!
            newPokemon.shiny = URL(string: "https://example.com/shiny\(pokemonId).png")!

            // Example favorite status
            // newPokemon.favorite = (index % 2 == 0) // true for even indexes
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    // It holds the actual data (the database)
    let container: NSPersistentContainer

    // Just a regular init function
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Dex")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
