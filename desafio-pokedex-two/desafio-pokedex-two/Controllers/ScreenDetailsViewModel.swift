//
//  ScreenDetailsViewModel.swift
//  desafio-pokedex-two
//
//  Created by Émerson M Luz on 29/01/23.
//

import UIKit

class ScreenDetailsViewModel: UIViewController {

    var apiBrain = ApiBrain()
    var abilities: [Abilities]?
    var type: [Types]?
    var stats: [Stats]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    internal func apiRequest(pokemon: Pokemon) {
        apiBrain.request(url: pokemon.habilityURL, type: AbilitiesList.self)
        apiBrain.request(url: "https://pokeapi.co/api/v2/pokemon-form/\(pokemon.id)/", type: TypeList.self)
        apiBrain.request(url: "https://pokeapi.co/api/v2/pokemon/\(pokemon.id)/", type: StatsList.self)
    }
    
}
