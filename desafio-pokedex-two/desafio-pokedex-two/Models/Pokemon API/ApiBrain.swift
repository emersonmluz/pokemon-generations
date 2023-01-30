//
//  ApiBrain.swift
//  desafio-pokedex-two
//
//  Created by Émerson M Luz on 25/01/23.
//

import Foundation

class ApiBrain {
    func request<Generic: Codable>(url: String,
                                   type: Generic.Type,
                                   completion: @escaping((Generic) -> Void)){
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
                let response = try decoder.decode(Generic.self, from: data!)
                DispatchQueue.main.async {
                    completion(response)
                }
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
}
