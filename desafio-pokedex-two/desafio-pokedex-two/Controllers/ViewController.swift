//
//  ViewController.swift
//  desafio-pokedex-two
//
//  Created by Émerson M Luz on 25/11/22.
//

import UIKit

class ViewController: UIViewController {

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
                    print(pokemons)
                }
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
}

