//
//  ContentManager.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 9/28/21.
//

import Foundation
import Firebase
import CodableFirebase

class ContentManager{
    static let shared = ContentManager()
    
    // Create
    func create(content: Content, onSuccess: @escaping (_ errorMessage: String?) -> Void){
        let data = try! FirestoreEncoder().encode(content)
        Firestore.firestore().collection("content").addDocument(data: data){ err in
            onSuccess(err?.localizedDescription)
        }
    }
    
    
    // Read
    func get(id: String, onSuccess: @escaping (_ content: Content) -> Void) {
        Firestore.firestore().collection("content").document(id).getDocument { document, error in
            if let document = document {
                let content = try! FirestoreDecoder().decode(Content.self, from: document.data()!)
                onSuccess(content)
            } else {
                print("Document does not exist")
            }
        }

    }
    
    // Update
    
    // Delete
}
