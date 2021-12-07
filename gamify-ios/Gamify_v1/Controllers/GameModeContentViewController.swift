//
//  GameModeContentViewController.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 11/28/21.
//

import UIKit

class GameModeContentViewController: UIViewController {

    @IBOutlet weak var contentImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!{
        didSet {
        titleLabel.numberOfLines = 0
        }
    }
    
    var index = 0
    var heading = ""
    var subHeading = ""
    var image = UIImage()
    var bgColor = UIColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextLabel()
        contentImageView.image = image
        view.backgroundColor = bgColor
    }
    
    func setupTextLabel() {
    let attributedText = NSMutableAttributedString(string: heading, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
    NSAttributedString.Key.foregroundColor: UIColor.white])
    attributedText.append(NSAttributedString(string: "\n\n\(subHeading)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.white]))
    titleLabel.attributedText = attributedText
    titleLabel.textAlignment = .center
    }
}
