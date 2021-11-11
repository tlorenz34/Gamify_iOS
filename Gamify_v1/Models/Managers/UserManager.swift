//
//  UserManager.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 9/23/21.
//

import Foundation
import Firebase
import CodableFirebase

let COLLECTION_USER = "users"

class UserManager{
    
    
    static let shared = UserManager()
    
    var currentUser: User!
    
    var userRef: DatabaseReference {
        Database.database().reference().child("users").ref
    }
    
    func loadCurrentUser(userId: String){
        get(id: userId) { user in
            self.currentUser = user
        }
    }
    
    // Create
    
    
    func create(user: User, onSuccess: @escaping (_ errorMessage: String?) -> Void){
        let data = try! FirestoreEncoder().encode(user)
        Firestore.firestore().collection(COLLECTION_USER)
            .document(user.id)
            .setData(data) { err in
            onSuccess(err?.localizedDescription)
        }
    }
    
    
    // Read
    func get(id: String, onSuccess: @escaping (_ user: User) -> Void) {
        print("id \(id)")
        Firestore.firestore().collection(COLLECTION_USER).document(id).getDocument { document, error in
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
