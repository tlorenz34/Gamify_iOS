//
//  ShareGameViewController.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 12/22/21.
//

import UIKit

class ShareGameViewController: UIViewController {

    @IBOutlet weak var exitButton: UIButton!
    
    @IBOutlet weak var congratsLabel: UILabel!
    
    @IBOutlet weak var shareLinkLabel: UILabel!
    
    @IBOutlet weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func tappedShare(_ sender: UIButton) {
        let url = "https://testflight.apple.com/join/mcloUhHb"
        
        let ac = UIActivityViewController(activityItems: ["Download Gamify and join the funniest video game. Vote on your favorite submissions to determine the winner.", url], applicationActivities: nil)        
        self.present(ac, animated: true)
    }
    

}
