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

class ContentManager {
    
    static let shared = ContentManager()
    
    let db = Firestore.firestore()
    
    static let CONTENT_LIMIT = 50
    
    private let submissionsCollectionKey = "content"
    private var baseQuery: Query {
        return db.collection(submissionsCollectionKey)
    }
    
    // Generates a random but valid document id
    func getDocumentId() -> String{
        return db.collection(COLLECTION_CONTENT).document().documentID
    }
        
    // Create
    func create(content: Content, onSuccess: @escaping (_ errorMessage: String?) -> Void){
        
        let data = try! FirestoreEncoder().encode(content)
        db.collection(COLLECTION_CONTENT)
            .document(content.id)
            .setData(data){ err in
            Crashlytics.crashlytics().log("Function: create content - ContentManager")
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
    
    
    // Given array of content, return an array of duals
    func convertContentToDuals(content: [Content]) -> [ContentDual]{
        let blocked = UserManager.shared.currentUser?.blockUserIds ?? [""]
        var duals = [ContentDual]()
        
        var latestDual = ContentDual()
        
        for c in content {
            if !blocked.contains(where: ({$0 == c.userId}))
            {
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
        }
        
        // Complete the dual with 1 content with a random one
        if latestDual.content2 == nil, content.count > 1{
            
            repeat {
                let random = content.randomElement()!
                if random.id != latestDual.content1.id && !blocked.contains(where: ({$0 == random.userId})) {
                    latestDual.content2 = random
                }
                
            } while latestDual.content2 == nil
            
            duals.append(latestDual)
        }
        return duals
    }
    
    
    func listTopContent(onSuccess: @escaping (_ content: [Content]) -> Void) {
        if let game = GameManager.shared.currentGame
        {
            db.collection(COLLECTION_CONTENT)
                .limit(to: 10)
                .order(by: "voteCount", descending: true).whereField("gameName", in: [game.name])
                .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    let content = querySnapshot!.documents.map{
                        try! FirestoreDecoder().decode(Content.self, from: $0.data())
                    }
                    onSuccess(content)
                }
            }
        }

    }
    func listCurrentUserContent(onSuccess: @escaping (_ content: [Content]) -> Void) {
        db.collection(COLLECTION_CONTENT).whereField("username", isEqualTo: "\(UserManager.shared.currentUser.username!)").getDocuments { (querySnapshot, err) in
        if let err = err{
            print("error getting documents \(err)")
            
        } else {
            let content = querySnapshot!.documents.map{
                try! FirestoreDecoder().decode(Content.self, from: $0.data())
            }
            onSuccess(content)
        }
    }
//        if let game = GameManager.shared.currentGame
//        {
//            db.collection(COLLECTION_CONTENT)
//                .limit(to: 10)
//                .order(by: "voteCount", descending: true).whereField("gameName", in: [game.name])
//                .getDocuments { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    let content = querySnapshot!.documents.map{
//                        try! FirestoreDecoder().decode(Content.self, from: $0.data())
//                    }
//                    onSuccess(content)
//                }
//            }
//        }

    }
 
   


    


    
    func addVote(contentId: String) {
        print("addVote called")
        
        db.collection(COLLECTION_CONTENT).document(contentId).updateData([
            "voteCount": FieldValue.increment(Int64(1))
        ]){ err in
            if let err = err{
                Crashlytics.crashlytics().log("Function: addVote - ContentManager")

                print(err)
            }
        }
    }
    
    
    // map / reduce --> functional programming
    // Firestore document -> native swift structure --> View Controller
    
    func list(after contentId: String?, onSuccess: @escaping (_ duals: [ContentDual]) -> Void){
        
        let process: FIRQuerySnapshotBlock = { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                let content = querySnapshot!.documents.map{
                    try! FirestoreDecoder().decode(Content.self, from: $0.data())
                }
                let duals = self.convertContentToDuals(content: content)
                
                DispatchQueue.main.async {
                    onSuccess(duals)
                }
            }
        }
        var gameName = "funniest"
        if let game = GameManager.shared.currentGame
        {
            gameName = game.name
        }
        
        if let contentId = contentId{
            db.collection(COLLECTION_CONTENT)
                .document(contentId)
                .getDocument { snapshot, err in
                    self.db.collection(COLLECTION_CONTENT)
                        .whereField("gameName", in: [gameName])
                        .start(afterDocument: snapshot!)
                        .limit(to: ContentManager.CONTENT_LIMIT)
                        .getDocuments(completion: process)
                }
        } else{
            db.collection(COLLECTION_CONTENT)
                .whereField("gameName", in: [gameName])
                .limit(to: ContentManager.CONTENT_LIMIT)
                .getDocuments(completion: process)
        }

    }
    
    // Update
    
    // Delete
}



// Concurrency / threads
// Main Thread - responding to user events, updating user interface
// Background Thread - waiting for a network request to come back, saving to a file system, long running operations

// A thread can only run one line of code a a ime

// Main Thread
// A
// B - 20 seconds
// C

// Rules
// 1. Long running process should ALWAYS be in a background thread
// 2. User interface updates should be in main thread

// We don't really know if it's in a background or main thread

// Grand Central Dispatch

