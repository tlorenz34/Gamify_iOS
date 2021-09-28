//
//  ChallengeManager.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 9/28/21.
//

import Foundation
import Firebase
import CodableFirebase

class ChallengeManager{
    static let shared = ChallengeManager()
    
    // Create
    func create(challenge: Challenge, onSuccess: @escaping (_ errorMessage: String?) -> Void){
        let data = try! FirestoreEncoder().encode(challenge)
        Firestore.firestore().collection("challenge").addDocument(data: data){ err in
            onSuccess(err?.localizedDescription)
        }
    }
    
    
    // Read
    func get(id: String, onSuccess: @escaping (_ challenge: Challenge) -> Void) {
        Firestore.firestore().collection("challenge").document(id).getDocument { document, error in
            if let document = document {
                let challenge = try! FirestoreDecoder().decode(Challenge.self, from: document.data()!)
                onSuccess(challenge)
            } else {
                print("Document does not exist")
            }
        }

    }
    
    // Update
    
    // Delete
}
