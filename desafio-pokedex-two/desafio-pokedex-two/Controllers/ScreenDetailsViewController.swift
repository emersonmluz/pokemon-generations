//
//  ScreenDetailsViewController.swift
//  desafio-pokedex-two
//
//  Created by Émerson M Luz on 27/11/22.
//

import UIKit

class ScreenDetailsViewController: UIViewController {

    var pokemon: Pokemon?
    var abilities: [Abilities]?
    var type: [Types]?
    var stats: [Stats]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPokemonAbilities()
        loadType()
        loadStats()
        // Do any additional setup after loading the view.
    }
    
    func loadPokemonAbilities () {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(self.pokemon!.id)/")
        
        guard url != nil else {return}
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("aplication/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            guard data != nil, error == nil else {return}
            
            do {
                let decoder = JSONDecoder()
                let abilitiesList = try decoder.decode(AbilitiesList.self, from: data!)
                
                DispatchQueue.main.async {
                    self.abilities = abilitiesList.abilities
                }
                
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
    func loadType () {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon-form/\(self.pokemon!.id)/")
        
        guard url != nil else {return}
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("aplication/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            guard data != nil, error == nil else {return}
            
            do {
                let decoder = JSONDecoder()
                let typeList = try decoder.decode(TypeList.self, from: data!)
                
                DispatchQueue.main.async {
                    self.type = typeList.types
                }
                
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }

    
    
    func loadStats () {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(self.pokemon!.id)/")
        
        guard url != nil else {return}
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("aplication/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            guard data != nil, error == nil else {return}
            
            do {
                let decoder = JSONDecoder()
                let statFile = try decoder.decode(StatsList.self, from: data!)
                
                DispatchQueue.main.async {
                    self.stats = statFile.stats
                    print(self.stats![0].baseStat)
                    print(self.stats![0].stat["name"]!)
                }
                
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
}
