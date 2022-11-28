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
    
    
    var pokemon: [Pokemon] = []
    var arrayOfSearch: [Pokemon] = []
    var generationI: Int = 151

    override func viewDidLoad() {
        tableView.dataSource = self
        
        startLoadingScreen()
        loadPokemonList()
        
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let detailsScreen = storyboard?.instantiateViewController(withIdentifier: "ScreenDetails") as! ScreenDetailsViewController
            
            
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
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?offset=0&limit=\(generationI)")
        
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
        
        let home = HomeViewController()
        let tapImageLeft = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        cell.pokemonImageLeft.addGestureRecognizer(tapImageLeft)
        cell.pokemonImageLeft.isUserInteractionEnabled = true
        
        let tapImageRight = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        cell.pokemonImageRight.addGestureRecognizer(tapImageRight)
        cell.pokemonImageRight.isUserInteractionEnabled = true

        
        return cell
    }
    
    
}
