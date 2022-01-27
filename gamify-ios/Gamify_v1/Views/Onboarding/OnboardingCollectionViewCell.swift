//
//  CollectionViewCell.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 1/27/22.
//

import UIKit
import Lottie

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var animationContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UILabel!
        
    static let identifier = "OnboardingCollectionViewCell"
    
    // Instance of the Lottie AnimationView
    var animation = AnimationView()

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // function to configure the cell
    func configureCell(_ page: Page){
        self.animation.removeFromSuperview()
        self.animation = AnimationView(name: page.animationName)

        // define the animation and the size
        animation.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height * 0.8)
        
        // customize the animation
        animation.animationSpeed = 1
        animation.loopMode = .loop
        animation.play()

        animationContainer.addSubview(animation)

        // set the title and description of the screen

        self.titleLabel.text = page.title
        self.descriptionTextView.text = page.description
    }
    
}
