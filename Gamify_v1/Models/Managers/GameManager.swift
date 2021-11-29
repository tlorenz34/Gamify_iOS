//
//  ChallengeManager.swift
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
    func create(challenge: GameMode, onSuccess: @escaping (_ errorMessage: String?) -> Void){
        let data = try! FirestoreEncoder().encode(challenge)
        Firestore.firestore().collection("challenge").addDocument(data: data){ err in
            onSuccess(err?.localizedDescription)
        }
    }
    
    
    // Read
    func get(id: String, onSuccess: @escaping (_ challenge: GameMode) -> Void) {
        Firestore.firestore().collection("challenge").document(id).getDocument { document, error in
            if let document = document {
                let challenge = try! FirestoreDecoder().decode(GameMode.self, from: document.data()!)
                onSuccess(challenge)
            } else {
                print("Document does not exist")
            }
        }

    }
    
    // Update
    
    // Delete
}
