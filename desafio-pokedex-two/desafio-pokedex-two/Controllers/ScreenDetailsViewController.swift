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
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var screenDetailsModel = ScreenDetailsViewModel()
    var pokemon: Pokemon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    private func configUI() {
        startLoadingScreen()
        screenDetailsModel.apiBrain.delegate = self
        configComponents()
        loadPokemonInfo()
        if let pokemon = pokemon {
            screenDetailsModel.apiRequest(pokemon: pokemon)
        }
    }
    
    private func configComponents() {
        contornoView.layer.cornerRadius = 150
        statsView.layer.cornerRadius = 10
        statsStackView.layer.cornerRadius = 10
    }
    
    private func loadPokemonInfo() {
        guard let pokemon = pokemon else {return}
        pokemonImageView.loadFrom(URLAddress: pokemon.imageURL)
        pokemonName.text = pokemon.name
    }
    
    private func startLoadingScreen() {
        loading.isHidden = false
        loading.startAnimating()
    }
    
    private func stopLoadingScreen() {
        loading.stopAnimating()
        loading.isHidden = true
    }
    
}

extension ScreenDetailsViewController: RequestDealings {
    func decoderSuccess<T>(data: T) {
        if let abilityList = data as? AbilitiesList {
            screenDetailsModel.abilities = abilityList.abilities
            self.pokemonTechLabel[0].text = screenDetailsModel.abilities![0].ability["name"]
            if screenDetailsModel.abilities!.count > 1 {
                self.pokemonTechLabel[1].text = screenDetailsModel.abilities![1].ability["name"]
                self.pokemonTechLabel[1].isHidden = false
                self.techLabel.isHidden = false
            } else {
                self.pokemonTechLabel[1].isHidden = true
                self.techLabel.isHidden = true
            }
        }
        
        if let type = data as? TypeList {
            screenDetailsModel.type = type.types
            self.pokemonTypeLabel.text = screenDetailsModel.type![0].type["name"]!
            if screenDetailsModel.type?.count ?? 0
                > 1 {
                self.pokemonTypeLabel.text? += " / " + (screenDetailsModel.type?[1].type["name"]!)!
            }
            self.containerView.backgroundColor = UIColor(named: (screenDetailsModel.type?[0].type["name"]!)!)
            self.progressBar.progressTintColor = UIColor(named: (screenDetailsModel.type?[0].type["name"]!)!)
        }
        
        if let stats = data as? StatsList {
            screenDetailsModel.stats = stats.stats
            self.hpLabel.text = "HP " + String(screenDetailsModel.stats?[0].baseStat ?? 0) + " / " + String(screenDetailsModel.stats?[0].baseStat ?? 0)
            self.statsValuesLabel[0].text = String(screenDetailsModel.stats?[1].baseStat ?? 0)
            self.statsValuesLabel[1].text = String(screenDetailsModel.stats?[2].baseStat ?? 0)
            self.statsValuesLabel[2].text = String(screenDetailsModel.stats?[3].baseStat ?? 0)
            self.statsValuesLabel[3].text = String(screenDetailsModel.stats?[4].baseStat ?? 0)
            self.statsValuesLabel[4].text = String(screenDetailsModel.stats?[5].baseStat ?? 0)
        }
        stopLoadingScreen()
    }
}
