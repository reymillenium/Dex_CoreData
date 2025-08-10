//
//  ContentView.swift
//  Dex
//
//  Created by Reinier Garcia on 8/8/25.
//

import CoreData
import SwiftUI

struct MainScreen: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)], animation: .default)
    private var pokemons: FetchedResults<Pokemon>

    var body: some View {
        NavigationView {
            List {
                ForEach(pokemons) { pokemon in
                    NavigationLink {
                        Text("Pokemon with name: \(pokemon.name!)")
                    } label: {
                        Text(pokemon.name!)
                    }
                }
                .onDelete(perform: deletePokemons)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addPokemon) {
                        Label("Add Pokemon", systemImage: "plus")
                    }
                }
            }
            Text("Select a Pokemon")
        }
    }

    private func addPokemon() {
        withAnimation {
            let newPokemon = Pokemon(context: viewContext)

            let randomID = Int16.random(in: 0 ... Int16.max)
            newPokemon.id = randomID
            newPokemon.name = "Pokémon \(randomID)"
            newPokemon.types = ["normal"] // no cast

            // Example stats (dummy values)
            newPokemon.hp = 50
            newPokemon.attack = 55
            newPokemon.defense = 45
            newPokemon.specialAttack = 60
            newPokemon.specialDefense = 50
            newPokemon.speed = 65

            // Example URLs (replace with real sprite links)
            newPokemon.sprite = URL(string: "https://example.com/sprite\(randomID).png")!
            newPokemon.shiny = URL(string: "https://example.com/shiny\(randomID).png")!

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deletePokemons(offsets: IndexSet) {
        withAnimation {
            offsets.map { pokemons[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview("pokemonId") {
    MainScreen().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
