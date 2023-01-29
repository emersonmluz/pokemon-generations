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
    
    var homeModel = HomeViewModel()
    var sound: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    private func configUI() {
        startLoadingScreen()
        configComponents()
        //configSound()
        delegateAndSourcce()
        hideKeyboard()
        homeModel.apiRequest()
    }
    
    private func configComponents() {
        generationsPopUpButton.layer.cornerRadius = 6
        setPopUpButton()
    }
    
    private func delegateAndSourcce() {
        homeModel.apiBrain.delegate = self
        tableView.dataSource = self
        searchTextField.delegate = self
    }
    
    private func configSound() {
        sound = AudioFile.importAudioFile()
        sound?.numberOfLoops = -1
        sound?.play()
    }
    
    private func hideKeyboard() {
        let touch = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(touch)
    }
    
    private func setPopUpButton () {
        self.startLoadingScreen()
        homeModel.addGenerations()
        guard let changeGeneration = homeModel.optionClosure else {return}
        generationsPopUpButton.menu = UIMenu(children: [
            UIAction(title: Generations.generationI.rawValue, state: .on, handler: changeGeneration),
            UIAction(title: Generations.generationII.rawValue, handler: changeGeneration),
            UIAction(title: Generations.generationIII.rawValue, handler: changeGeneration),
            UIAction(title: Generations.generationIV.rawValue, state: .on, handler: changeGeneration),
            UIAction(title: Generations.generationV.rawValue, state: .on, handler: changeGeneration),
            UIAction(title: Generations.generationVI.rawValue, state: .on, handler: changeGeneration),
            UIAction(title: Generations.generationVII.rawValue, state: .on, handler: changeGeneration),
            UIAction(title: Generations.generationVIII.rawValue, state: .on, handler: changeGeneration)
        ])
    }
    
    @IBAction func searchButtonClick(_ sender: UIButton) {
        startLoadingScreen()
        homeModel.search(name: searchTextField.text ?? "")
        tableView.reloadData()
        stopLoadingScreen()
    }
    
    @objc func imageTapped(sender: MyTapGesture) {
        view.endEditing(true)
        if sender.state == .ended {
            let detailsScreen = storyboard?.instantiateViewController(withIdentifier: "ScreenDetails") as! ScreenDetailsViewController
           
            detailsScreen.pokemon = homeModel.pokemonList[sender.id! - homeModel.numberOfOldPokemonsInGenerationPrevious]
            
            navigationController?.pushViewController(detailsScreen, animated: true)
        }
    }

    func startLoadingScreen() {
        loadingActivityIndicator.isHidden = false
        loadingActivityIndicator.startAnimating()
    }
    
    func stopLoadingScreen() {
        loadingActivityIndicator.stopAnimating()
        loadingActivityIndicator.isHidden = true
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRows: Double = 0
        
        if homeModel.arrayOfSearch.count > 0 {
            numberOfRows = Double(homeModel.arrayOfSearch.count) / 2
            nothingResultLabel.alpha = 0
        } else if searchTextField.text != "" {
            nothingResultLabel.alpha = 1
        } else {
            numberOfRows = Double(homeModel.pokemonList.count) / 2
            nothingResultLabel.alpha = 0
        }
        
        searchTextField.text = ""
        numberOfRows = ceil(numberOfRows)
        
        return Int(numberOfRows)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CellSetup
        
        if homeModel.arrayOfSearch.count > 0 {
            cell.loadCell(pokemonOne: homeModel.arrayOfSearch[indexPath.row], pokemonTwo: homeModel.arrayOfSearch[homeModel.arrayOfSearch.count / 2 + indexPath.row])
        } else {
            cell.loadCell(pokemonOne: homeModel.pokemonList[indexPath.row], pokemonTwo: homeModel.pokemonList[(homeModel.pokemonList.count / 2) + indexPath.row])
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
        startLoadingScreen()
        homeModel.search(name: searchTextField.text ?? "")
        tableView.reloadData()
        stopLoadingScreen()
        return true
    }
    
}

extension HomeViewController: RequestDealings {
    func decoderSuccess<T>(data: T) {
        if let pokemon = data as? PokemonList {
            homeModel.pokemonList = pokemon.result
            self.tableView.reloadData()
            self.stopLoadingScreen()
        }
    }
}
