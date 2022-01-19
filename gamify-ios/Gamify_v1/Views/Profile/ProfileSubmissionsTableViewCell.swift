//
//  ProfileSubmissionsTableViewCell.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 1/13/22.
//

import UIKit

class ProfileSubmissionsTableViewCell: UITableViewCell {

    @IBOutlet weak var playSubmissionButton: UIButton!
    
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        playSubmissionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)


    }
    func configure(content: Content){
        
        playSubmissionButton.setTitle("\(content.gameName)", for: .normal)

    
    }
    
    

}
