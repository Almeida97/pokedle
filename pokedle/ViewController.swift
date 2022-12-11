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
    var allPokemonNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.guessTextField.delegate = self
        self.tableView.register(UINib(nibName: "CustomHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "CustomHeaderView")
//        Service.fetchAutoCompleteList { resultsArray in
//            print(resultsArray)
//        }
        allPokemonNames = Service.fetchAutoCompleteList().allNames
        //let done = Service.fetchAutoCompleteList().filteredNames("ra")
        newGame()
        
    }
    
    func newGame(){
        Service.fetchPokemon(name: "\(Int.random(in: 0 ..< 10))") { [weak self] pokemon in
            self?.correctPokemon = pokemon
            print(pokemon?.name)
        }
        pokemonGuesses = []
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func checkPokemon() {
        var userGuess = Guess(pokemon: nil, nameColor: .systemGray, typeColor: .systemGray, pokemonImage: nil)
        if userPokemon?.name != correctPokemon?.name  {
            if userPokemon?.types[0].type == correctPokemon?.types[0].type{
                userGuess = Guess(pokemon: userPokemon, nameColor: .red, typeColor: .orange, pokemonImage: nil)
            }else{
                userGuess = Guess(pokemon: userPokemon, nameColor: .red, typeColor: .red, pokemonImage: nil)
            }
        }else{
            userGuess = Guess(pokemon: userPokemon, nameColor: .green, typeColor: .green, pokemonImage: nil)
            let alert = UIAlertController(title: "You got that in \(pokemonGuesses.count+1)", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "New Game", style: .default, handler:  { [weak self] action in
                self!.newGame()
            }))
            DispatchQueue.main.async {
                self.present(alert, animated: true)
                self.tableView.reloadData()
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
            if pokemon == nil {
//                let alert = UIAlertController(title: "Error", message: "Please insert a valid pokemon", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default))
                DispatchQueue.main.async {
                    self?.present(self!.showAlert(title: "Error", message: "Please insert a valid pokemon"), animated: true)
                }
            }else{
                self!.userPokemon = pokemon
                self!.checkPokemon()
            }
        }
        guessTextField.text = ""
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
    
    func showAlert(title: String, message: String)-> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        return alert
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""

          // attempt to read the range they are trying to change, or exit if we can't
          guard let stringRange = Range(range, in: currentText) else { return false }

          // add their new text to the existing text
          let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        let filteredNames = allPokemonNames.filter { $0.starts(with: updatedText) }
        print(filteredNames.count)
        return true
        
    }
    

    
}

