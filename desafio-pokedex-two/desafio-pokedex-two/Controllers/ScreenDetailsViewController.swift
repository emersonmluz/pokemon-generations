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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPokemonAbilities()
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
                    print(self.abilities![0].ability["name"]!)
                }
                
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }

}
