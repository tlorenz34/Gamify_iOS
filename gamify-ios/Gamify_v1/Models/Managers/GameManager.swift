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
    
    // Create
    func create(game: Game, onSuccess: @escaping (_ errorMessage: String?) -> Void){
        let data = try! FirestoreEncoder().encode(game)
        Firestore.firestore().collection("game").addDocument(data: data){ err in
            onSuccess(err?.localizedDescription)
        }
    }
    
    
    // Read
    func get(id: String, onSuccess: @escaping (_ game: Game) -> Void) {
        Firestore.firestore().collection("game").document(id).getDocument { document, error in
            if let document = document {
                let game = try! FirestoreDecoder().decode(Game.self, from: document.data()!)
                onSuccess(game)
            } else {
                print("Document does not exist")
            }
        }

    }
    

}
