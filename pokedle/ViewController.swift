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

class ViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var guessTextField: UITextField!
    @IBOutlet weak var guessButton: UIButton!
    
    let correctGuess = Guess(pokeName: "charmander", type: "Fire")
    var pokemon: Pokemon?
    var guesses: [Guess] = [] /* = [Guess(pokeName: "Pokemon", type: "Type(s)", pokeNameBackgroundColor: .gray, typeBackgroundColor: .gray)]*/
    
    @IBAction func guessButtonTapped(_ sender: Any) {
        var userGuess = Guess(pokeName: guessTextField.text, type: "Fire")
        
        if userGuess.pokeName == correctGuess.pokeName {
            userGuess.pokeNameBackgroundColor = .green
            userGuess.typeBackgroundColor = .green
            guesses.insert(userGuess, at: 0)
        }else{
            userGuess.pokeNameBackgroundColor = .red
            if userGuess.type == correctGuess.type{
                userGuess.typeBackgroundColor = .orange
                
            }else{
                userGuess.typeBackgroundColor = .red
            }
            guesses.insert(userGuess, at: 0)
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "CustomHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "CustomHeaderView")
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

