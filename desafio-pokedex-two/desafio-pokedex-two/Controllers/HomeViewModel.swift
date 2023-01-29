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
    var optionClosure: ((UIAction) -> Void)?
    
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
    
    internal func addGenerations() {
        optionClosure = {(action: UIAction) in
            
            switch action.title {
            case Generations.generationI.rawValue:
                self.numberOfOldPokemonsInGenerationPrevious = 0
                self.numberOfNewPokemonsInGenerationCurrent = 151
            case Generations.generationII.rawValue:
                self.numberOfOldPokemonsInGenerationPrevious = 151
                self.numberOfNewPokemonsInGenerationCurrent = 100
            case Generations.generationIII.rawValue:
                self.numberOfOldPokemonsInGenerationPrevious = 251
                self.numberOfNewPokemonsInGenerationCurrent = 135
            case Generations.generationIV.rawValue:
                self.numberOfOldPokemonsInGenerationPrevious = 386
                self.numberOfNewPokemonsInGenerationCurrent = 107
            case Generations.generationV.rawValue:
                self.numberOfOldPokemonsInGenerationPrevious = 493
                self.numberOfNewPokemonsInGenerationCurrent = 156
            case Generations.generationVI.rawValue:
                self.numberOfOldPokemonsInGenerationPrevious = 649
                self.numberOfNewPokemonsInGenerationCurrent = 72
            case Generations.generationVII.rawValue:
                self.numberOfOldPokemonsInGenerationPrevious = 721
                self.numberOfNewPokemonsInGenerationCurrent = 88
            case Generations.generationVIII.rawValue:
                self.numberOfOldPokemonsInGenerationPrevious = 809
                self.numberOfNewPokemonsInGenerationCurrent = 96
            default:
                break
            }
          
            self.arrayOfSearch = []
            self.apiRequest()
        }
    }
}
