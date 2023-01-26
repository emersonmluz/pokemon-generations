//
//  ApiBrain.swift
//  desafio-pokedex-two
//
//  Created by Émerson M Luz on 25/01/23.
//

import Foundation

protocol RequestDealings {
    func decoderSuccess<T>(data: T)
}

class ApiBrain {
    var delegate: RequestDealings?
    
    func request<Generic: Codable>(url: String, type: Generic.Type) {
        let url = URL(string: url)
        
        guard url != nil else {return}
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("aplication/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            guard data != nil, error == nil else {return}
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(PokemonList.self, from: data!)
             
                DispatchQueue.main.async {
                    self.delegate?.decoderSuccess(data: response)
                }
                
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
}
