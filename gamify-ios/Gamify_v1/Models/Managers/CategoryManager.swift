//
//  CategoryManager.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 9/28/21.
//

import Foundation
import Firebase
import CodableFirebase

class CategoryManager{
    static let shared = CategoryManager()
    
    // Create
    func create(category: Category, onSuccess: @escaping (_ errorMessage: String?) -> Void){
        let data = try! FirestoreEncoder().encode(category)
        Firestore.firestore().collection("category").addDocument(data: data){ err in
            onSuccess(err?.localizedDescription)
        }
    }
    
    // comment
    // Read
    func get(id: String, onSuccess: @escaping (_ category: Category) -> Void) {
        Firestore.firestore().collection("category").document(id).getDocument { document, error in
            if let document = document {
                let category = try! FirestoreDecoder().decode(Category.self, from: document.data()!)
                onSuccess(category)
            } else {
                print("Document does not exist")
            }
        }

    }
    
    // Update
    
    // Delete
}


// Todos in order
// 1. Storage of videos
// 2. Showing / playing a video from Firebase storage
// 3. Scrolling between two videos
// 4. API, Algorithm for showing videos, etc....
