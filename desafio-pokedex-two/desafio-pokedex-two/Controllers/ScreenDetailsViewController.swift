//
//  ScreenDetailsViewController.swift
//  desafio-pokedex-two
//
//  Created by Émerson M Luz on 27/11/22.
//

import UIKit

class ScreenDetailsViewController: UIViewController {
    
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var pokemonName: UILabel!
    @IBOutlet weak var hpLabel: UILabel!
    
    @IBOutlet weak var pokemonTypeLabel: UILabel!
    @IBOutlet var pokemonTechLabel: [UILabel]!
    @IBOutlet var statsValuesLabel: [UILabel]!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var statsView: UIView!
    @IBOutlet weak var statsStackView: UIStackView!
    @IBOutlet weak var techLabel: UILabel!
    
    var pokemon: Pokemon?
    var abilities: [Abilities]?
    var type: [Types]?
    var stats: [Stats]?
    var encounters: [LocationArea]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPokemonAbilities()
        loadType()
        loadStats()
        loadLocationArea()
        
        pokemonImageView.loadImage(URLAddress: pokemon!.imageURL)
        pokemonName.text = pokemon?.name
        
        statsView.layer.cornerRadius = 10
        statsStackView.layer.cornerRadius = 10
        
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
                    self.pokemonTechLabel[0].text = self.abilities![0].ability["name"]
                    if self.abilities!.count > 1 {
                        self.pokemonTechLabel[1].text = self.abilities![1].ability["name"]
                        self.pokemonTechLabel[1].isHidden = false
                        self.techLabel.isHidden = false
                    } else {
                        self.pokemonTechLabel[1].isHidden = true
                        self.techLabel.isHidden = true
                    }
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
                    self.pokemonTypeLabel.text = self.type![0].type["name"]!
                    if self.type!.count
                        > 1 {
                        self.pokemonTypeLabel.text? += " / " + (self.type?[1].type["name"]!)!
                    }
                    self.containerView.backgroundColor = UIColor(named: (self.type?[0].type["name"]!)!)
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
                    self.hpLabel.text = "HP " + String(self.stats?[0].baseStat ?? 0) + " / " + String(self.stats?[0].baseStat ?? 0)
                    self.statsValuesLabel[0].text = String(self.stats?[1].baseStat ?? 0)
                    self.statsValuesLabel[1].text = String(self.stats?[2].baseStat ?? 0)
                    self.statsValuesLabel[2].text = String(self.stats?[3].baseStat ?? 0)
                    self.statsValuesLabel[3].text = String(self.stats?[4].baseStat ?? 0)
                    self.statsValuesLabel[4].text = String(self.stats?[5].baseStat ?? 0)
                }
                
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
    func loadLocationArea () {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(self.pokemon!.id)/encounters")
        
        guard url != nil else {return}
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("aplication/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            guard data != nil, error == nil else {return}
            
            do {
                let decoder = JSONDecoder()
                let area = try decoder.decode([LocationArea].self, from: data!)

                DispatchQueue.main.async {
                    self.encounters = area
                }
                
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
}

extension UIImageView {
    func loadImage(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.global().async {
            let imageData = try? Data(contentsOf: url)
            
            DispatchQueue.main.async { [weak self] in
                if let imageData = imageData {
                    if let loadedImage = UIImage(data: imageData) {
                            self?.image = loadedImage
                    }
                }
            }
        }

    }
}
