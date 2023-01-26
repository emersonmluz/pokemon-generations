//
//  ViewController.swift
//  desafio-pokedex-two
//
//  Created by Émerson M Luz on 25/11/22.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var nothingResultLabel: UILabel!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var generationsPopUpButton: UIButton!
    
    var apiBrain = ApiBrain()
    var pokemon: [Pokemon] = []
    var arrayOfSearch: [Pokemon] = []
    var numberOfNewPokemonsInGenerationCurrent: Int = 151
    var numberOfOldPokemonsInGenerationPrevious: Int = 0
    var sound: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiBrain.delegate = self
        tableView.dataSource = self
        searchTextField.delegate = self
        
        sound = AudioFile.importAudioFile()
        sound?.numberOfLoops = -1
        sound?.play()
        
        startLoadingScreen()

        apiBrain.request(url: "https://pokeapi.co/api/v2/pokemon?offset=\(numberOfOldPokemonsInGenerationPrevious)&limit=\(numberOfNewPokemonsInGenerationCurrent)", type: PokemonList.self)
        
        generationsPopUpButton.layer.cornerRadius = 6
        setPopUpButton()
        
        touchScreen()
    }
    
    @objc func dismissKeyboard () {
        searchTextField.resignFirstResponder()
    }
    
    func touchScreen () {
        let touch = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(touch)
    }
    
    func setPopUpButton () {
        
        let optionClosure = {(action: UIAction) in
            
            switch action.title {
            case Generations.generationI.rawValue:
                self.numberOfOldPokemonsInGenerationPrevious = 0
                self.numberOfNewPokemonsInGenerationCurrent = 151
            case Generations.generationII.rawValue:
                self.numberOfOldPokemonsInGenerationPrevious = 151
                self.numberOfNewPokemonsInGenerationCurrent = 100
            case Generations.generationIII.rawValue:
                self.numberOfOldPokemonsInGenerationPrevious = 251
                self.numberOfNewPokemonsInGenerationCurrent = 135
            case Generations.generationIV.rawValue:
                self.numberOfOldPokemonsInGenerationPrevious = 386
                self.numberOfNewPokemonsInGenerationCurrent = 107
            case Generations.generationV.rawValue:
                self.numberOfOldPokemonsInGenerationPrevious = 493
                self.numberOfNewPokemonsInGenerationCurrent = 156
            case Generations.generationVI.rawValue:
                self.numberOfOldPokemonsInGenerationPrevious = 649
                self.numberOfNewPokemonsInGenerationCurrent = 72
            case Generations.generationVII.rawValue:
                self.numberOfOldPokemonsInGenerationPrevious = 721
                self.numberOfNewPokemonsInGenerationCurrent = 88
            case Generations.generationVIII.rawValue:
                self.numberOfOldPokemonsInGenerationPrevious = 809
                self.numberOfNewPokemonsInGenerationCurrent = 96
            default:
                self.nothingResultLabel.text = "ERROR: Erro interno no app!"
            }
            
            self.dismissKeyboard()
            self.arrayOfSearch = []
            self.startLoadingScreen()
            self.apiBrain.request(url: "https://pokeapi.co/api/v2/pokemon?offset=\(self.numberOfOldPokemonsInGenerationPrevious)&limit=\(self.numberOfNewPokemonsInGenerationCurrent)", type: PokemonList.self)
            
        }
        
        generationsPopUpButton.menu = UIMenu(children: [
            UIAction(title: Generations.generationI.rawValue, state: .on, handler: optionClosure),
            UIAction(title: Generations.generationII.rawValue, handler: optionClosure),
            UIAction(title: Generations.generationIII.rawValue, handler: optionClosure),
            UIAction(title: Generations.generationIV.rawValue, state: .on, handler: optionClosure),
            UIAction(title: Generations.generationV.rawValue, state: .on, handler: optionClosure),
            UIAction(title: Generations.generationVI.rawValue, state: .on, handler: optionClosure),
            UIAction(title: Generations.generationVII.rawValue, state: .on, handler: optionClosure),
            UIAction(title: Generations.generationVIII.rawValue, state: .on, handler: optionClosure)
        ])
    }
    
    @IBAction func searchButtonClick(_ sender: UIButton) {
        dismissKeyboard()
        startLoadingScreen()
        search()
        tableView.reloadData()
        stopLoadingScreen()
    }
    
    func search () {
        let searchName: String = searchTextField.text ?? ""
        arrayOfSearch = []
        
        for pokemon in pokemon {
            if pokemon.name.lowercased().contains(searchName.lowercased()) {
                arrayOfSearch.append(pokemon)
            }
        }
    }
    
    @objc func imageTapped(sender: MyTapGesture) {
        dismissKeyboard()
        if sender.state == .ended {
            let detailsScreen = storyboard?.instantiateViewController(withIdentifier: "ScreenDetails") as! ScreenDetailsViewController
           
            detailsScreen.pokemon = pokemon[sender.id! - numberOfOldPokemonsInGenerationPrevious]
            
            navigationController?.pushViewController(detailsScreen, animated: true)
        }
    }

    func startLoadingScreen () {
        loadingActivityIndicator.alpha = 1
        tableView.alpha = 0.5
        tableView.isUserInteractionEnabled = false
    }
    
    func stopLoadingScreen () {
        loadingActivityIndicator.alpha = 0
        tableView.alpha = 1
        tableView.isUserInteractionEnabled = true
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRows: Double = 0
        
        if arrayOfSearch.count > 0 {
            numberOfRows = Double(arrayOfSearch.count) / 2
            nothingResultLabel.alpha = 0
        } else if searchTextField.text != "" {
            nothingResultLabel.alpha = 1
        } else {
            numberOfRows = Double(pokemon.count) / 2
            nothingResultLabel.alpha = 0
        }
        
        searchTextField.text = ""
        numberOfRows = ceil(numberOfRows)
        
        return Int(numberOfRows)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CellSetup
        
        if arrayOfSearch.count > 0 {
            cell.loadCell(pokemonOne: arrayOfSearch[indexPath.row], pokemonTwo: arrayOfSearch[arrayOfSearch.count / 2 + indexPath.row])
        } else {
            cell.loadCell(pokemonOne: pokemon[indexPath.row], pokemonTwo: pokemon[(pokemon.count / 2) + indexPath.row])
        }
        
        let tapImageLeft = MyTapGesture(target: self, action: #selector(imageTapped))
        tapImageLeft.id = Int(cell.idLeft.text!)! - 1
        cell.pokemonImageLeft.addGestureRecognizer(tapImageLeft)
        cell.pokemonImageLeft.isUserInteractionEnabled = true
        
        let tapImageRight = MyTapGesture(target: self, action: #selector(imageTapped))
        tapImageRight.id = Int(cell.idRight.text!)! - 1
        cell.pokemonImageRight.addGestureRecognizer(tapImageRight)
        cell.pokemonImageRight.isUserInteractionEnabled = true

        
        return cell
    }
    
}

class MyTapGesture: UITapGestureRecognizer {
    var id: Int?
}

extension HomeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        startLoadingScreen()
        search()
        tableView.reloadData()
        stopLoadingScreen()
        
        return true
    }
    
}

extension HomeViewController: RequestDealings {
    func decoderSuccess<T>(data: T) {
        if let pokemon = data as? PokemonList {
            self.pokemon = pokemon.result
            self.tableView.reloadData()
            self.stopLoadingScreen()
        }
    }
}
