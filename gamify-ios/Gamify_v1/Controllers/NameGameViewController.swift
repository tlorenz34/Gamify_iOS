//
//  NameGameViewController.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 11/29/21.
//

import UIKit
import Firebase

class NameGameViewController: UIViewController {

    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var nameGameTextField: UITextField!
    @IBOutlet weak var createGameButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tappedCreateButton(_ sender: UIButton) {
        uploadGame()
        performSegue(withIdentifier: "toCongratsGameIsLive", sender: self)
    }
    

    
    func uploadGame() {
        let gameName = self.nameGameTextField.text!
        let gameId = GameManager.shared.getDocumentId()
        let db = Firestore.firestore()
        let game = [
            "gameId": gameId,
            "gameName": gameName
        ]
        db.collection("game").addDocument(data: game)


    }
}
