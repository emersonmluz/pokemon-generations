//
//  Pokemon.swift
//  desafio-pokedex-two
//
//  Created by Émerson M Luz on 25/11/22.
//

import Foundation

class Pokemon: Codable {
    var id: String {
        var indentifier: String = ""
        var barNumber: Int = 0
    
        for letter in habilityURL {
            if letter == "/" {
                barNumber += 1
            }
            if barNumber == 6 && letter != "/" {
                indentifier += String(letter)
                
            }
        }
        
        return indentifier
    }
    
    var name: String
    var habilityURL: String
    var imageURL: String {
        let str = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/"
        var id: String = ""
        var barNumber: Int = 0
    
        for letter in habilityURL.reversed() {
            if letter == "/" {
                barNumber += 1
            }
            if barNumber == 1 && letter != "/" {
                id += String(letter)
                
            }
            if barNumber == 2 {
                break
            }
        }
        
        return str + id.reversed() + ".png"
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case habilityURL = "url"
    }
}
