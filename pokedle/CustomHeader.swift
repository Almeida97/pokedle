//
//  CustomHeader.swift
//  pokedle
//
//  Created by PAULO ALMEIDA on 19/11/2022.
//

import UIKit

class CustomHeader: UITableViewHeaderFooterView {
    
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerNameLabel: UILabel!
    @IBOutlet weak var headerTypeLabel: UILabel!
    
   
    
    override func awakeFromNib() {
        headerNameLabel.layer.masksToBounds = true
        headerNameLabel.layer.cornerRadius = 8
        headerTypeLabel.layer.masksToBounds = true
        headerTypeLabel.layer.cornerRadius = 8
        headerImage.layer.masksToBounds = true
        headerImage.layer.cornerRadius = 8
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
