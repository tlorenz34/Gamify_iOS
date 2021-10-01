//
//  ContentManager.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 9/28/21.
//

import Foundation
import Firebase
import CodableFirebase

let COLLECTION_CONTENT = "content"

class ContentManager{
    static let shared = ContentManager()
    
    let db = Firestore.firestore()
    
    // Create
    func create(content: Content, onSuccess: @escaping (_ errorMessage: String?) -> Void){
        let data = try! FirestoreEncoder().encode(content)
        db.collection(COLLECTION_CONTENT)
            .addDocument(data: data){ err in
            onSuccess(err?.localizedDescription)
        }
    }
    
    
    // Read
    func get(id: String, onSuccess: @escaping (_ content: Content) -> Void) {
        db.collection(COLLECTION_CONTENT)
            .document(id)
            .getDocument { document, error in
                if let document = document {
                    let content = try! FirestoreDecoder().decode(Content.self, from: document.data()!)
                    onSuccess(content)
            } else {
                print("Document does not exist")
            }
        }

    }
    
    // map / reduce --> functional programming
    // Firestore document -> native swift structure --> View Controller
    
    func list(onSuccess: @escaping (_ duals: [ContentDual]) -> Void){
        db.collection(COLLECTION_CONTENT)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    let content = querySnapshot!.documents.map{
                        try! FirestoreDecoder().decode(Content.self, from: $0.data()!)
                    }
                    
                    var duals = [ContentDual]()
                    
                    var latestDual = ContentDual()
                    
                    for c in content {
                        if latestDual.content1 == nil{
                            latestDual.content1 = c
                        } else if latestDual.content2 == nil{
                            latestDual.content2 = c
                            duals.append(latestDual)
                        } else{
                            latestDual = ContentDual()
                            latestDual.content1 = c
                        }
                    }
                    
                    
                    // Concurrency / threads
                    // Main Thread - responding to user events, updating user interface
                    // Background Thread - waiting for a network request to come back, saving to a file system, long running operations
                    
                    // A thread can only run one line of code a a time
                    
                    // Main Thread
                    // A
                    // B - 20 seconds
                    // C
                    
                    // Rules
                    // 1. Long running process should ALWAYS be in a background thread
                    // 2. User interface updates should be in main thread
                    
                    // We don't really know if it's in a background or main thread
                    
                    // Grand Central Dispatch
                    
                    DispatchQueue.main.async {
                        onSuccess(duals)
                    }
                }
        }

    }
    
    // Update
    
    // Delete
}
