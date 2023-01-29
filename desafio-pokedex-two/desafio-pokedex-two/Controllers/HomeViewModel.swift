//
//  HomeModel.swift
//  desafio-pokedex-two
//
//  Created by Émerson M Luz on 29/01/23.
//

import UIKit

class HomeViewModel: UIViewController {

    var apiBrain = ApiBrain()
    var pokemonList: [Pokemon] = []
    var arrayOfSearch: [Pokemon] = []
    var numberOfNewPokemonsInGenerationCurrent: Int = 151
    var numberOfOldPokemonsInGenerationPrevious: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    internal func apiRequest() {
        apiBrain.request(url: "https://pokeapi.co/api/v2/pokemon?offset=\(numberOfOldPokemonsInGenerationPrevious)&limit=\(numberOfNewPokemonsInGenerationCurrent)", type: PokemonList.self)
    }
    
    internal func search(name: String) {
        arrayOfSearch = []
        for pokemon in pokemonList {
            if pokemon.name.lowercased().contains(name.lowercased()) {
                arrayOfSearch.append(pokemon)
            }
        }
    }
}
