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
        screenDetailsModel.controller = self
        screenDetailsModel.apiRequest(pokemon: pokemon!)
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
    
    internal func startLoadingScreen() {
        loading.isHidden = false
        loading.startAnimating()
    }
    
    internal func stopLoadingScreen() {
        loading.stopAnimating()
        loading.isHidden = true
    }
    
}
