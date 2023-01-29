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
    @IBOutlet weak var pokemonImageLeft: UIImageView!
    @IBOutlet weak var pokemonImageRight: UIImageView!
    @IBOutlet weak var idLeft: UILabel!
    @IBOutlet weak var idRight: UILabel!
    
    func loadCell (pokemonOne: Pokemon, pokemonTwo: Pokemon) {
        pokemonImageLeft.layer.cornerRadius = 8
        pokemonImageRight.layer.cornerRadius = 8
        
        pokemonNameLeft.text = pokemonOne.name
        idLeft.text = pokemonOne.id
        pokemonImageLeft.loadFrom(URLAddress: pokemonOne.imageURL)
        
        if pokemonTwo.name != pokemonOne.name {
            pokemonNameRight.text = pokemonTwo.name
            idRight.text = pokemonTwo.id
            pokemonImageRight.loadFrom(URLAddress: pokemonTwo.imageURL)
        } else {
            pokemonNameRight.text = ""
            pokemonImageRight.image = nil
        }
    }
}
