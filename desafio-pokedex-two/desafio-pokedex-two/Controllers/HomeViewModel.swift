//
//  HomeModel.swift
//  desafio-pokedex-two
//
//  Created by Émerson M Luz on 29/01/23.
//

import UIKit

class HomeViewModel: UIViewController {

    var apiBrain = ApiBrain()
    var arrayOfSearch: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    internal func apiRequest(previouGeneration: Int, currentGeneration: Int) {
        apiBrain.request(url: "https://pokeapi.co/api/v2/pokemon?offset=\(previouGeneration)&limit=\(currentGeneration)", type: PokemonList.self)
    }
    
    internal func search(name: String, searchIn: [Pokemon]) {
        arrayOfSearch = []
        for pokemon in searchIn {
            if pokemon.name.lowercased().contains(name.lowercased()) {
                arrayOfSearch.append(pokemon)
            }
        }
    }
}
