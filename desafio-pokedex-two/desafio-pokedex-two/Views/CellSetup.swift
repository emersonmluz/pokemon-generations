//
//  CellSetup.swift
//  desafio-pokedex-two
//
//  Created by Émerson M Luz on 25/11/22.
//

import UIKit

class CellSetup: UITableViewCell {
    
    @IBOutlet weak var pokemonNameLeft: UILabel!
    @IBOutlet weak var pokemonNameRight: UILabel!
    @IBOutlet weak var pokemonImageLeft: UIView!
    @IBOutlet weak var pokemonImageRight: UIView!
    
    func loadCell (pokemonOne: Pokemon, pokemonTwo: Pokemon) {
        pokemonNameLeft.text = pokemonOne.name
        pokemonNameRight.text = pokemonTwo.name
    }
    
}
