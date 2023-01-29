//
//  HomeModel.swift
//  desafio-pokedex-two
//
//  Created by Émerson M Luz on 29/01/23.
//

import UIKit
import AVFAudio

class HomeViewModel: UIViewController {

    var apiBrain = ApiBrain()
    var pokemonList: [Pokemon] = []
    var arrayOfSearch: [Pokemon] = []
    var numberOfNewPokemonsInGenerationCurrent: Int = 151
    var numberOfOldPokemonsInGenerationPrevious: Int = 0
    var optionClosure: ((UIAction) -> Void)?
    weak var controller: HomeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    internal func apiRequest() {
        apiBrain.request(url: "https://pokeapi.co/api/v2/pokemon?offset=\(numberOfOldPokemonsInGenerationPrevious)&limit=\(numberOfNewPokemonsInGenerationCurrent)", type: PokemonList.self)
    }
    
    internal func search(name: String) {
        arrayOfSearch = []
        for pokemon in pokemonList {
            if pokemon.name.lowercased().contains(name.lowercased()) {
                arrayOfSearch.append(pokemon)
            }
        }
    }
    
    internal func addGenerations() {
        optionClosure = {(action: UIAction) in
            
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
                break
            }
          
            self.arrayOfSearch = []
            self.apiRequest()
        }
    }
    
    internal func importAudioFile () -> AVAudioPlayer {
        var audioFileResult: AVAudioPlayer?
        do {
            let path = Bundle.main.path(forResource: "pokemonTheme", ofType: "mp3")
            let audioFile = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
            audioFileResult = audioFile
        } catch {
            print("Arquivo de áudio não encontrado.")
        }
        return audioFileResult!
    }
    
    internal func numberOfRow() -> Int {
        var numberOfRows: Double = 0
        
        if arrayOfSearch.count > 0 {
            numberOfRows = Double(arrayOfSearch.count) / 2
            controller?.nothingResultLabel.alpha = 0
        } else if controller?.searchTextField.text != "" {
            controller?.nothingResultLabel.alpha = 1
        } else {
            numberOfRows = Double(pokemonList.count) / 2
            controller?.nothingResultLabel.alpha = 0
        }
        
        controller?.searchTextField.text = ""
        numberOfRows = ceil(numberOfRows)
        
        return Int(numberOfRows)
    }
    
    internal func cellRows(row: Int) -> UITableViewCell {
        let cell = controller?.tableView.dequeueReusableCell(withIdentifier: "cell") as! CellSetup
        
        if arrayOfSearch.count > 0 {
            cell.loadCell(pokemonOne: arrayOfSearch[row], pokemonTwo: arrayOfSearch[arrayOfSearch.count / 2 + row])
        } else {
            cell.loadCell(pokemonOne: pokemonList[row], pokemonTwo: pokemonList[(pokemonList.count / 2) + row])
        }
        
        let tapImageLeft = MyTapGesture(target: controller, action: #selector(controller?.imageTapped))
        tapImageLeft.id = Int(cell.idLeft.text!)! - 1
        cell.pokemonImageLeft.addGestureRecognizer(tapImageLeft)
        cell.pokemonImageLeft.isUserInteractionEnabled = true
        
        let tapImageRight = MyTapGesture(target: controller, action: #selector(controller?.imageTapped))
        tapImageRight.id = Int(cell.idRight.text!)! - 1
        cell.pokemonImageRight.addGestureRecognizer(tapImageRight)
        cell.pokemonImageRight.isUserInteractionEnabled = true
        
        return cell
    }
}

extension HomeViewModel: RequestDealings {
    func decoderSuccess<T>(data: T) {
        if let pokemon = data as? PokemonList {
            pokemonList = pokemon.result
            controller?.tableView.reloadData()
            controller?.stopLoadingScreen()
        }
    }
}

enum Generations: String {
    case generationI = "Geração I"
    case generationII = "Geração II"
    case generationIII = "Geração III"
    case generationIV = "Geração IV"
    case generationV = "Geração V"
    case generationVI = "Geração VI"
    case generationVII = "Geração VII"
    case generationVIII = "Geração VIII"
}

extension UIImageView {
    func loadFrom(URLAddress: String) {
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
