//
//  FetchService.swift
//  Dex
//
//  Created by Reinier Garcia on 8/12/25.
//

import Foundation

struct FetchService {
    enum FetchError: Error {
        case badResponse
    }

    private let baseURL: URL = .init(string: "https://pokeapi.co/api/v2/pokemon")!

    func fetchPokemon(for id: Int) async throws -> FetchedPokemon {
        let fetchURL = baseURL.appendingPathComponent(String(id))
        // // let fetchURL = baseURL.appending(path: String(id))
        // let (data, response) = try await URLSession.shared.data(from: fetchURL)
        // guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        //     // fatalError("Bad response")
        //     throw FetchError.badResponse
        // }

        // let decoder = JSONDecoder()
        // decoder.keyDecodingStrategy = .convertFromSnakeCase
        // let pokemon = try decoder.decode(FetchedPokemon.self, from: data)
        // print("Fetched pokemon \(pokemon.id): \(pokemon.name.capitalized)")
        // return pokemon

        do {
            let (data, response) = try await URLSession.shared.data(from: fetchURL)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw FetchError.badResponse
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let pokemon = try decoder.decode(FetchedPokemon.self, from: data)
            print("Fetched pokemon \(pokemon.id): \(pokemon.name.capitalized)")
            return pokemon
        } catch {
            if let e = error as? URLError {
                print("URLError: \(e.code) – \(e.localizedDescription)")
                print("Failing URL: \(fetchURL)")
            } else {
                print("Unexpected error: \(error)")
            }
            throw error // rethrow so caller knows it failed
        }
    }
}
