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
        let url = "https://apps.apple.com/us/app/gamify-social-mini-games/id1590780699"
        
        let ac = UIActivityViewController(activityItems: ["Hey - I have an invite to Gamify and want you to join. Here is the invite-only link to start creating mini-games with your friends.", url], applicationActivities: nil)        
        self.present(ac, animated: true)
    }
    

}
