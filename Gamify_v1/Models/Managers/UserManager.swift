//
//  UserManager.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 9/23/21.
//

import Foundation
import Firebase
import CodableFirebase

class UserManager{
    static let shared = UserManager()
    
    // Create
    func create(user: User, onSuccess: @escaping (_ errorMessage: String?) -> Void){
        let data = try! FirestoreEncoder().encode(user)
        Firestore.firestore().collection("users").addDocument(data: data){ err in
            onSuccess(err?.localizedDescription)
        }
    }
    
    
    // Read
    func get(id: String, onSuccess: @escaping (_ user: User) -> Void) {
        Firestore.firestore().collection("users").document(id).getDocument { document, error in
            if let document = document {
                let user = try! FirestoreDecoder().decode(User.self, from: document.data()!)
                onSuccess(user)
            } else {
                print("Document does not exist")
            }
        }

    }
    
    // Update
    
    // Delete
}

//UserManager.shared.createUser()
