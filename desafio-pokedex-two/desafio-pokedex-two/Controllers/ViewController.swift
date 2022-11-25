//
//  ViewController.swift
//  desafio-pokedex-two
//
//  Created by Émerson M Luz on 25/11/22.
//

import UIKit

class ViewController: UIViewController {
    
    var pokedex: PokemonList?
    var pokemon: [Pokemon] = []

    override func viewDidLoad() {
        
        loadPokemonList()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func loadPokemonList () {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?offset=0&limit=100")
        
        guard url != nil else {return}
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("aplication/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            guard data != nil, error == nil else {return}
            
            do {
                let decoder = JSONDecoder()
                let pokemons = try decoder.decode(PokemonList.self, from: data!)
                
                DispatchQueue.main.async {
                    for index in 0...pokemons.list.count - 1 {
                        self.pokemon.append(Pokemon(name: pokemons.list[index]["name"]!, habilityURL: pokemons.list[index]["url"]!))
                        print("Name: \(self.pokemon[index].name) \nHabilidade URL: \(self.pokemon[index].habilityURL) \nImagemURL: \(self.pokemon[index].imageURL)")
                    }
                    
                    self.pokedex = pokemons
                    
                }
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
}

