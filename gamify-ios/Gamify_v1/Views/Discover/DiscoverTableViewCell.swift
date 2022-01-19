//
//  DiscoverTableViewCell.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 11/30/21.
//

import UIKit

class DiscoverTableViewCell: UITableViewCell {

    @IBOutlet weak var gameTitle: UILabel!
    
    
    @IBOutlet weak var cellView: UIView!
    
    
    @IBOutlet weak var joinLabel: UILabel!
    func configure(with model: Game){
        
        gameTitle.text = model.name
        cellView.layer.cornerRadius = 8
        cellView.layer.masksToBounds = true
        cellView.layer.borderColor = UIColor.white.cgColor
        cellView.layer.borderWidth = 0.5
        
        joinLabel.layer.cornerRadius = 8
        joinLabel.layer.borderWidth = 0.75
        joinLabel.layer.masksToBounds = true

    }
    

}
