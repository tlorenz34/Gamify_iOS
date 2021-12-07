//
//  NameGameViewController.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 11/29/21.
//

import UIKit

class NameGameViewController: UIViewController {

    @IBOutlet weak var instructionsLabel: UILabel!
    
    
    @IBOutlet weak var nameGameTextField: UITextField!
    
    
    @IBOutlet weak var createGameButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    @IBAction func tappedCreateButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toCongratsGameIsLive", sender: self)
    }
    
}
