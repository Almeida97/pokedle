//
//  ViewController.swift
//  pokedle
//
//  Created by PAULO ALMEIDA on 14/11/2022.
//

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var guessTextField: UITextField!
    @IBOutlet weak var guessButton: UIButton!

    var correctPokemon: Pokemon?
    var userPokemon: Pokemon?
    var pokemonGuesses = [Guess]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "CustomHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "CustomHeaderView")
        
        // define correct answer hard coded for now
        Service.fetchPokemon(name: "mew") { [weak self] pokemon in
            self?.correctPokemon = pokemon
        }
    }
    
    func checkPokemon() {
        var userGuess = Guess(pokemon: nil, nameColor: .systemGray, typeColor: .systemGray, pokemonImage: nil)
        if userPokemon?.name != correctPokemon?.name  {

            if userPokemon?.types[0].type == correctPokemon?.types[0].type{
                userGuess = Guess(pokemon: userPokemon, nameColor: .red, typeColor: .green, pokemonImage: nil)
            }else{
                userGuess = Guess(pokemon: userPokemon, nameColor: .red, typeColor: .red, pokemonImage: nil)
            }
        }else{
            userGuess = Guess(pokemon: userPokemon, nameColor: .green, typeColor: .green, pokemonImage: nil)
            let alert = UIAlertController(title: "You got that in \(pokemonGuesses.count+1)", message: "New Game", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default,
                                                  handler: nil))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
        Service.fetchPokemonImage(url: (self.userPokemon?.sprites.front_default)!) { imageData in
            DispatchQueue.main.async { [weak self] in
                userGuess.pokemonImage = imageData
                self!.pokemonGuesses.insert(userGuess, at: 0)
                self!.tableView.reloadData()
            }
        }
    }
    
    @IBAction func guessButtonTapped(_ sender: Any) {
        guard let pokemonText = guessTextField.text, guessTextField.text != nil else{
            return
        }
        Service.fetchPokemon(name: pokemonText) { [weak self] pokemon in
            self!.userPokemon = pokemon
            self!.checkPokemon()
            
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeaderView") as! CustomHeader
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonGuesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokeTableViewCell", for: indexPath) as! PokeTableViewCell
        cell.cellType.layer.masksToBounds = true
        cell.cellLabel.layer.masksToBounds = true
        cell.cellType.layer.cornerRadius = 8
        cell.cellLabel.layer.cornerRadius = 8
        cell.cellImage.image = UIImage(data: pokemonGuesses[indexPath.row].pokemonImage!)
        cell.cellLabel.text = pokemonGuesses[indexPath.row].pokemon?.name
        cell.cellType.text = pokemonGuesses[indexPath.row].pokemon?.alltypesString
        cell.cellType.backgroundColor = pokemonGuesses[indexPath.row].typeColor
        cell.cellLabel.backgroundColor = pokemonGuesses[indexPath.row].nameColor
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

