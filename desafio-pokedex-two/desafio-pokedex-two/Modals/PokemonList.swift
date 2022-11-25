//
//  PokemonList.swift
//  desafio-pokedex-two
//
//  Created by Émerson M Luz on 25/11/22.
//

import Foundation

struct PokemonList: Codable {
    var pokemon: [[String: String]]
    
    enum CodingKeys: String, CodingKey {
        case pokemon = "results"
    }
}
