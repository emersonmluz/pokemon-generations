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
        configSound()
        delegateAndSourcce()
        hideKeyboard()
        homeModel.apiRequest()
    }
    
    private func configComponents() {
        generationsPopUpButton.layer.cornerRadius = 6
        setPopUpButton()
    }
    
    private func delegateAndSourcce() {
        homeModel.controller = self
        homeModel.apiRequest()
        tableView.dataSource = self
        searchTextField.delegate = self
    }
    
    private func configSound() {
        sound = homeModel.importAudioFile()
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

    internal func startLoadingScreen() {
        loadingActivityIndicator.isHidden = false
        loadingActivityIndicator.startAnimating()
    }
    
    internal func stopLoadingScreen() {
        loadingActivityIndicator.stopAnimating()
        loadingActivityIndicator.isHidden = true
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeModel.numberOfRow()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return homeModel.cellRows(row: indexPath.row)
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


