//
//  DiscoverTableViewCell.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 11/30/21.
//

import UIKit

class DiscoverTableViewCell: UITableViewCell {

    @IBOutlet weak var gameTitle: UILabel!
    
    func configure(with model: Game){
        gameTitle.text = model.name
    }
    

}
