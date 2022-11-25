//
//  Pokemon.swift
//  desafio-pokedex-two
//
//  Created by Émerson M Luz on 25/11/22.
//

import Foundation

struct Pokemon {
    var name: String
    var habilityURL: String
    var imageURL: String
    
    init(name: String, habilityURL: String, imageURL: String) {
        self.name = name
        self.habilityURL = habilityURL
        self.imageURL = imageURL
    }
}
