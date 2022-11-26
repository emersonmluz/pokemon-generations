//
//  ViewController.swift
//  desafio-pokedex-two
//
//  Created by Émerson M Luz on 25/11/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var pokemon: [Pokemon] = []

    override func viewDidLoad() {
        tableView.dataSource = self
        
        loadPokemonList()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func loadPokemonList () {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?offset=0&limit=151")
        
        guard url != nil else {return}
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("aplication/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            guard data != nil, error == nil else {return}
            
            do {
                let decoder = JSONDecoder()
                let pokemonList = try decoder.decode(PokemonList.self, from: data!)
                
                DispatchQueue.main.async {
                    self.pokemon = pokemonList.result
                    self.tableView.reloadData()
                }
                
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemon.count / 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CellSetup
        
        cell.loadCell(pokemonOne: pokemon[indexPath.row], pokemonTwo: pokemon[(pokemon.count / 2) + indexPath.row])
        return cell
    }
    
    
}
