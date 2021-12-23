//
//  GameManager.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 9/28/21.
//

import Foundation
import Firebase
import CodableFirebase

class GameManager{
    static let shared = GameManager()
    
    let db = Firestore.firestore()
    
    var currentGame: Game!

    let COLLECTION_CONTENT = "game"

    func getDocumentId() -> String{
        return db.collection(COLLECTION_CONTENT).document().documentID
    }
    // Create
    func create(game: Game, onSuccess: @escaping (_ errorMessage: String?) -> Void){
        let data = try! FirestoreEncoder().encode(game)
        db.collection(COLLECTION_CONTENT)
            .document(game.id)
            .setData(data){ err in
            onSuccess(err?.localizedDescription)
            }
    }
    // Read
    func get(id: String, onSuccess: @escaping (_ game: Game) -> Void) {
        db.collection(COLLECTION_CONTENT)
            .document(id)
            .getDocument { document, error in
                if let document = document {
                    let game = try! FirestoreDecoder().decode(Game.self, from: document.data()!)
                    onSuccess(game)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    //update
    func updateSubmissionCount(id: String)
    {
        db.collection(COLLECTION_CONTENT).document(id).getDocument() { (document, err) in
            if let document = document {
                if let submission = document.get("submissions") as? Int
                {
                    document.reference.updateData([
                        "submissions": submission+1
                    ])
                    GameManager.shared.currentGame.numberOfSubmissions = submission+1
                }
                else
                {
                    document.reference.updateData([
                        "submissions": 1
                    ])
                    GameManager.shared.currentGame.numberOfSubmissions = 1
                }
            }
        }
    }

}
