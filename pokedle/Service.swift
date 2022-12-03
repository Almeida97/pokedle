//
//  Service.swift
//  pokedle
//
//  Created by PAULO ALMEIDA on 03/12/2022.
//

import Foundation
class Service {
    
    static func fetchPokemon(name: String) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(name)") else{
            return
        }
        let task = URLSession.shared.dataTask(with: url) {data, response, error in
            guard let data = data, error == nil else{
                return
            }
            do {
                let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)

            }catch {
                print(error)
            }
        }
        task.resume()
    }
}

struct Pokemon: Codable {
    
    var name: String
    var types: [Types]
    var sprites: Sprite
}

struct Sprite: Codable{
    
    var back_default: String?
    var back_female: String?
    var back_shiny: String?
    var back_shiny_female: String?
    var front_default: String?
    var front_female: String?
    var front_shiny: String?
    var front_shiny_female: String?
}

struct Types: Codable {
    var slot: Int
    var type: type
}

struct type: Codable{
    var name: String
    var url : String
}
