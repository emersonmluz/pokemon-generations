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
    @IBOutlet weak var contornoView: UIView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var pokemon: Pokemon?
    var abilities: [Abilities]?
    var type: [Types]?
    var stats: [Stats]?
    var apiBrain = ApiBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiBrain.delegate = self
        
        contornoView.layer.cornerRadius = 150
        
        pokemonImageView.loadImage(URLAddress: pokemon!.imageURL)
        pokemonName.text = pokemon?.name
        
        statsView.layer.cornerRadius = 10
        statsStackView.layer.cornerRadius = 10
        requestApi()
        
        
        // Do any additional setup after loading the view.
    }
    
    func requestApi() {
        apiBrain.request(url: pokemon!.habilityURL, type: AbilitiesList.self)
        apiBrain.request(url: "https://pokeapi.co/api/v2/pokemon-form/\(self.pokemon!.id)/", type: TypeList.self)
        apiBrain.request(url: "https://pokeapi.co/api/v2/pokemon/\(self.pokemon!.id)/", type: StatsList.self)
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

extension ScreenDetailsViewController: RequestDealings {
    func decoderSuccess<T>(data: T) {
        if let abilityList = data as? AbilitiesList {
            self.abilities = abilityList.abilities
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
        
        if let type = data as? TypeList {
            self.type = type.types
            self.pokemonTypeLabel.text = self.type![0].type["name"]!
            if self.type!.count
                > 1 {
                self.pokemonTypeLabel.text? += " / " + (self.type?[1].type["name"]!)!
            }
            self.containerView.backgroundColor = UIColor(named: (self.type?[0].type["name"]!)!)
            self.progressBar.progressTintColor = UIColor(named: (self.type?[0].type["name"]!)!)
        }
        
        if let stats = data as? StatsList {
            self.stats = stats.stats
            self.hpLabel.text = "HP " + String(self.stats?[0].baseStat ?? 0) + " / " + String(self.stats?[0].baseStat ?? 0)
            self.statsValuesLabel[0].text = String(self.stats?[1].baseStat ?? 0)
            self.statsValuesLabel[1].text = String(self.stats?[2].baseStat ?? 0)
            self.statsValuesLabel[2].text = String(self.stats?[3].baseStat ?? 0)
            self.statsValuesLabel[3].text = String(self.stats?[4].baseStat ?? 0)
            self.statsValuesLabel[4].text = String(self.stats?[5].baseStat ?? 0)
        }
    }
}
