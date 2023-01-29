//
//  Stats.swift
//  desafio-pokedex-two
//
//  Created by Émerson M Luz on 28/11/22.
//

import Foundation

struct Stats: Codable {
    var baseStat: Int
    var stat: [String: String]
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}
