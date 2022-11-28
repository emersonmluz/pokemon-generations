//
//  ViewController.swift
//  desafio-pokedex-two
//
//  Created by Émerson M Luz on 25/11/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var nothingResultLabel: UILabel!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var generationsPopUpButton: UIButton!
    
    var pokemon: [Pokemon] = []
    var arrayOfSearch: [Pokemon] = []
    var numberOfNewPokemonsInGenerationCurrent: Int = 151
    var numberOfOldPokemonsInGenerationPrevious: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        startLoadingScreen()
        loadPokemonList()
        
        generationsPopUpButton.layer.cornerRadius = 6
        setPopUpButton()
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
            
            self.loadPokemonList()
            
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
        if sender.state == .ended {
            let detailsScreen = storyboard?.instantiateViewController(withIdentifier: "ScreenDetails") as! ScreenDetailsViewController
            
            detailsScreen.pokemon = pokemon[Int(sender.id!)!]
            
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
    
    func loadPokemonList () {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?offset=\(numberOfOldPokemonsInGenerationPrevious)&limit=\(numberOfNewPokemonsInGenerationCurrent)")
        
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
                    self.stopLoadingScreen()
                }
                
            } catch let error {
                print(error)
            }
        }
        task.resume()
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
        tapImageLeft.id = String(indexPath.row)
        cell.pokemonImageLeft.addGestureRecognizer(tapImageLeft)
        cell.pokemonImageLeft.isUserInteractionEnabled = true
        
        let tapImageRight = MyTapGesture(target: self, action: #selector(imageTapped))
        tapImageRight.id = String((pokemon.count / 2) + indexPath.row)
        cell.pokemonImageRight.addGestureRecognizer(tapImageRight)
        cell.pokemonImageRight.isUserInteractionEnabled = true

        
        return cell
    }
    
}

class MyTapGesture: UITapGestureRecognizer {
    var id: String?
}
