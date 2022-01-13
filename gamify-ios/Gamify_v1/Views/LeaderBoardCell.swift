//
//  LeaderBoardCell.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 11/2/21.
//

import UIKit

class LeaderBoardCell: UITableViewCell {
    

    @IBOutlet weak var positionLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var votesLabel: UILabel!
    
    @IBOutlet weak var playVideoButton: UIButton!
    
    func updateUI(position: Int, content: Content){
        positionLabel.text = "\(String(describing: position.ordinal!))"
        
        usernameLabel.text = content.username
        votesLabel.text = "\(content.voteCount) votes"

        
    }

}

private var ordinalFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .ordinal
    return formatter
}()

extension Int {
    var ordinal: String! {
        return ordinalFormatter.string(from: NSNumber(value: self))
    }
}

