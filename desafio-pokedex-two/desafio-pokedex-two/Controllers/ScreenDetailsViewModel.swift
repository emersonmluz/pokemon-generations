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
        apiBrain.request(url: pokemon.habilityURL, type: AbilitiesList.self) { (response) in
            self.controller?.startLoadingScreen()
            self.abilities = response.abilities
            self.controller?.pokemonTechLabel[0].text = self.abilities![0].ability["name"]
            if self.abilities!.count > 1 {
                self.controller?.pokemonTechLabel[1].text = self.abilities![1].ability["name"]
                self.controller?.pokemonTechLabel[1].isHidden = false
                self.controller?.techLabel.isHidden = false
            } else {
                self.controller?.pokemonTechLabel[1].isHidden = true
                self.controller?.techLabel.isHidden = true
            }
            self.controller?.stopLoadingScreen()
        }
        
        apiBrain.request(url: "https://pokeapi.co/api/v2/pokemon-form/\(pokemon.id)/", type: TypeList.self) { (response) in
            self.controller?.startLoadingScreen()
            self.type = response.types
            self.controller?.pokemonTypeLabel.text = self.type![0].type["name"]!
            if self.type?.count ?? 0
                > 1 {
                self.controller?.pokemonTypeLabel.text? += " / " + (self.type?[1].type["name"]!)!
            }
            self.controller?.containerView.backgroundColor = UIColor(named: (self.type?[0].type["name"]!)!)
            self.controller?.progressBar.progressTintColor = UIColor(named: (self.type?[0].type["name"]!)!)
            self.controller?.stopLoadingScreen()
        }
        
        apiBrain.request(url: "https://pokeapi.co/api/v2/pokemon/\(pokemon.id)/", type: StatsList.self) { (response) in
            self.controller?.startLoadingScreen()
            self.stats = response.stats
            self.controller?.hpLabel.text = "HP " + String(self.stats?[0].baseStat ?? 0) + " / " + String(self.stats?[0].baseStat ?? 0)
            self.controller?.statsValuesLabel[0].text = String(self.stats?[1].baseStat ?? 0)
            self.controller?.statsValuesLabel[1].text = String(self.stats?[2].baseStat ?? 0)
            self.controller?.statsValuesLabel[2].text = String(self.stats?[3].baseStat ?? 0)
            self.controller?.statsValuesLabel[3].text = String(self.stats?[4].baseStat ?? 0)
            self.controller?.statsValuesLabel[4].text = String(self.stats?[5].baseStat ?? 0)
            self.controller?.stopLoadingScreen()
        }
    }
}
