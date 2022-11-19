//
//  ViewController.swift
//  pokedle
//
//  Created by PAULO ALMEIDA on 14/11/2022.
//

import UIKit

struct Guess {
    var pokeName: String?
    var type: String?
    var pokeNameBackgroundColor: UIColor?
    var typeBackgroundColor: UIColor?
    
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var guessTextField: UITextField!
    @IBOutlet weak var guessButton: UIButton!
    
    let correctGuess = Guess(pokeName: "charmander", type: "Fire")
    
   
    
    var guesses: [Guess] = [Guess(pokeName: "Pokemon", type: "Type(s)", pokeNameBackgroundColor: .gray, typeBackgroundColor: .gray)]
    
    @IBAction func guessButtonTapped(_ sender: Any) {
        var userGuess = Guess(pokeName: guessTextField.text, type: "Fire")
        if userGuess.pokeName == correctGuess.pokeName {
            userGuess.pokeNameBackgroundColor = .green
            userGuess.typeBackgroundColor = .green
            guesses.insert(userGuess, at: 1)
        }else{
            //IF the name is not correct then check each type to see if green , red or orange
            //fetch guess pokemon types and for each type check if equal to correct guess pokemon types , if atleast one passes then background color orange else automaticly red
            userGuess.pokeNameBackgroundColor = .red
            if userGuess.type == correctGuess.type{
                userGuess.typeBackgroundColor = .orange
                
            }else{
                userGuess.typeBackgroundColor = .red
            }
            guesses.insert(userGuess, at: 1)
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokeTableViewCell", for: indexPath) as! PokeTableViewCell
        cell.cellType.layer.masksToBounds = true
        cell.cellLabel.layer.masksToBounds = true
        cell.cellType.layer.cornerRadius = 8
        cell.cellLabel.layer.cornerRadius = 8
        cell.cellLabel.text = guesses[indexPath.row].pokeName
        cell.cellLabel.backgroundColor = guesses[indexPath.row].pokeNameBackgroundColor
        cell.cellType.text = guesses[indexPath.row].type
        cell.cellType.backgroundColor = guesses[indexPath.row].typeBackgroundColor
        return cell

        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }


}

