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
    weak var controller: ScreenDetailsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    internal func apiRequest(pokemon: Pokemon) {
        apiBrain.request(url: pokemon.habilityURL, type: AbilitiesList.self)
        apiBrain.request(url: "https://pokeapi.co/api/v2/pokemon-form/\(pokemon.id)/", type: TypeList.self)
        apiBrain.request(url: "https://pokeapi.co/api/v2/pokemon/\(pokemon.id)/", type: StatsList.self)
    }
    
}

extension ScreenDetailsViewModel: RequestDealings {
    func decoderSuccess<T>(data: T) {
        if let abilityList = data as? AbilitiesList {
            abilities = abilityList.abilities
            controller?.pokemonTechLabel[0].text = abilities![0].ability["name"]
            if abilities!.count > 1 {
                controller?.pokemonTechLabel[1].text = abilities![1].ability["name"]
                controller?.pokemonTechLabel[1].isHidden = false
                controller?.techLabel.isHidden = false
            } else {
                controller?.pokemonTechLabel[1].isHidden = true
                controller?.techLabel.isHidden = true
            }
        }
        
        if let type = data as? TypeList {
            self.type = type.types
            controller?.pokemonTypeLabel.text = self.type![0].type["name"]!
            if self.type?.count ?? 0
                > 1 {
                controller?.pokemonTypeLabel.text? += " / " + (self.type?[1].type["name"]!)!
            }
            controller?.containerView.backgroundColor = UIColor(named: (self.type?[0].type["name"]!)!)
            controller?.progressBar.progressTintColor = UIColor(named: (self.type?[0].type["name"]!)!)
        }
        
        if let stats = data as? StatsList {
            self.stats = stats.stats
            controller?.hpLabel.text = "HP " + String(self.stats?[0].baseStat ?? 0) + " / " + String(self.stats?[0].baseStat ?? 0)
            controller?.statsValuesLabel[0].text = String(self.stats?[1].baseStat ?? 0)
            controller?.statsValuesLabel[1].text = String(self.stats?[2].baseStat ?? 0)
            controller?.statsValuesLabel[2].text = String(self.stats?[3].baseStat ?? 0)
            controller?.statsValuesLabel[3].text = String(self.stats?[4].baseStat ?? 0)
            controller?.statsValuesLabel[4].text = String(self.stats?[5].baseStat ?? 0)
        }
        controller?.stopLoadingScreen()
    }
}
