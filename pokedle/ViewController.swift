//
//  ViewController.swift
//  pokedle
//
//  Created by PAULO ALMEIDA on 14/11/2022.
//

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet weak var pokemonTableView: UITableView!
    @IBOutlet weak var guessTextField: UITextField!
    @IBOutlet weak var guessButton: UIButton!
    var autoCompleteTableView = UITableView()
    
    var correctPokemon: Pokemon?
    var userPokemon: Pokemon?
    var pokemonGuesses = [Guess]()
    var allPokemonNames = [String]()
    var filteredPokemonNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pokemonTableView.delegate = self
        self.pokemonTableView.dataSource = self
        self.guessTextField.delegate = self
        self.pokemonTableView.register(UINib(nibName: "CustomHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "CustomHeaderView")
        allPokemonNames = Service.fetchAutoCompleteList().allNames
        newGame()
        
    }
    
    func newGame(){
        Service.fetchPokemon(name: "\(Int.random(in: 0 ..< 10))") { [weak self] pokemon in
            self?.correctPokemon = pokemon
            print(pokemon?.name)
        }
        pokemonGuesses = []
        DispatchQueue.main.async {
            self.pokemonTableView.reloadData()
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
                self.pokemonTableView.reloadData()
            }
        }
        Service.fetchPokemonImage(url: (self.userPokemon?.sprites.front_default)!) { imageData in
            DispatchQueue.main.async { [weak self] in
                userGuess.pokemonImage = imageData
                self!.pokemonGuesses.insert(userGuess, at: 0)
                self!.pokemonTableView.reloadData()
            }
        }
    }

    @IBAction func guessButtonTapped(_ sender: Any) {
        guard let pokemonText = guessTextField.text?.lowercased(), guessTextField.text != nil else{
            return
        }
        filteredPokemonNames = []
        autoCompleteTableView.reloadData()
        autoCompleteTableView.isHidden = true
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

    func tableViewSetUp(){
        autoCompleteTableView.frame = CGRect(x: guessTextField.frame.minX-10, y: guessTextField.frame.minY-150, width: (guessTextField.frame.width + guessButton.frame.width)+20, height: 150)
        autoCompleteTableView.layer.masksToBounds = true
        autoCompleteTableView.register(UITableViewCell.self, forCellReuseIdentifier: "autoCompleteCell")
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == pokemonTableView {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeaderView") as! CustomHeader
        return headerView
        }
        let headerView = UITableViewHeaderFooterView(reuseIdentifier: "random")
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == pokemonTableView {
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == autoCompleteTableView {
            return filteredPokemonNames.count
        }else{
            return pokemonGuesses.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == autoCompleteTableView {
            guessTextField.text = filteredPokemonNames[indexPath.row]
            filteredPokemonNames = []
            autoCompleteTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == autoCompleteTableView {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "autoCompleteCell")
            cell.textLabel?.text = filteredPokemonNames[indexPath.row]
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PokeTableViewCell", for: indexPath) as! PokeTableViewCell
            cell.cellImage.image = UIImage(data: pokemonGuesses[indexPath.row].pokemonImage!)
            cell.cellLabel.text = pokemonGuesses[indexPath.row].pokemon?.name
            cell.cellType.text = pokemonGuesses[indexPath.row].pokemon?.alltypesString
            cell.cellType.backgroundColor = pokemonGuesses[indexPath.row].typeColor
            cell.cellLabel.backgroundColor = pokemonGuesses[indexPath.row].nameColor
            return cell
        }
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
        autoCompleteTableView.delegate = self
        autoCompleteTableView.dataSource = self
        autoCompleteTableView.tag = 18
        view.addSubview(autoCompleteTableView)
        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        autoCompleteTableView.isHidden = false
        filteredPokemonNames = allPokemonNames.filter { $0.starts(with: updatedText.lowercased()) }
        tableViewSetUp()
        DispatchQueue.main.async {
            self.autoCompleteTableView.reloadData()
        }
        return true
        
    }
    

    
}

