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
            let randomID = Int16.random(in: 0 ... Int16.max)
            _ = Pokemon(
                context: viewContext,
                id: randomID,
                name: "Pokémon \(randomID)",
                types: ["normal"],
                hp: 50, attack: 55, defense: 45,
                specialAttack: 60, specialDefense: 50, speed: 65,
                sprite: URL(string: "https://example.com/sprite\(randomID).png")!,
                shiny: URL(string: "https://example.com/shiny\(randomID).png")!
            )

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

#Preview("MainScreen") {
    MainScreen().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
