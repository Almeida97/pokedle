//
//  PokeTableViewCell.swift
//  pokedle
//
//  Created by PAULO ALMEIDA on 14/11/2022.
//

import UIKit

class PokeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellType: UILabel!
    
    override func awakeFromNib() {
        cellType.layer.masksToBounds = true
        cellLabel.layer.masksToBounds = true
        cellType.layer.cornerRadius = 8
        cellLabel.layer.cornerRadius = 8
    }
    
}
