//
//  Service.swift
//  pokedle
//
//  Created by PAULO ALMEIDA on 03/12/2022.
//

import Foundation
import UIKit
class Service {

    static func fetchPokemon(name: String, completion: @escaping (Pokemon)-> Void){
        
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(name)") else{
            return
        }
        let task = URLSession.shared.dataTask(with: url) {data, response, error in
            guard let data = data, error == nil else{
                return
            }
            do {
                let dataDecoded = try JSONDecoder().decode(Pokemon.self, from: data)
                completion(dataDecoded)
            }catch {
                print(error)
            }
            
        }
        task.resume()
    }
    
    static func fetchPokemonImage(url: String, completion: @escaping (Data)-> Void){
        
        guard let url = URL(string: url) else{
            return
        }
        let task = URLSession.shared.dataTask(with: url) {data, response, error in
            guard let data = data, error == nil else{
                return
            }
            completion(data)
            
        }
        task.resume()
    }
}

struct Pokemon: Codable {
    var name: String
    var types: [Types]
    var sprites: Sprite
    
    var alltypesString: String{
        var keep = ""
        for type in types {
            if !(keep.isEmpty) {
                keep += "/\(type.type.name)"
            }
            keep.append(type.type.name)
        }
        return keep
    }
    
    var typesArray: [String] {
        var array: [String] = []
        for type in types {
            array.append(type.type.name)
        }
        return array
    }
    
    init(name: String, types: [Types], sprites: Sprite, alltypesString: String, typesArray: [String]) {
            self.name = name
        self.types = types
        self.sprites = sprites
            
        }
    
}

struct Sprite: Codable {
    var front_default: String?
}

struct Types: Codable {
    var slot: Int
    var type: type
    
}

struct type: Codable, Equatable {
    var name: String
    var url : String
}


struct Guess {
    var pokemon : Pokemon?
    var nameColor: UIColor
    var typeColor: UIColor
    var pokemonImage: Data?
    
    init(pokemon: Pokemon?, nameColor: UIColor, typeColor: UIColor, pokemonImage: Data?) {
        self.pokemon = pokemon
        self.nameColor = nameColor
        self.typeColor = typeColor
        self.pokemonImage = pokemonImage
       }
}

