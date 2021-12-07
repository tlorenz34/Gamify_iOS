//
//  SubmissionManager.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 9/21/21.
//

import Foundation
import Firebase


struct SubmissionManager {
    
    let db = Firestore.firestore()
    private let submissionsCollectionKey = "submissions"
    private var baseQuery: Query {
        return db.collection(submissionsCollectionKey)
    }
    private var submissionsCollectionRef: CollectionReference {
        return db.collection(submissionsCollectionKey)
    }
    
    func fetchSubmissions(submissions: String, completion: @escaping (([Submissions]?) -> Void)) {
        baseQuery.whereField("submissions", isEqualTo: submissions)
            .getDocuments { (snapshot, error) in
                guard let snapshot = snapshot else {
                    completion(nil)
                    return
                }
                completion(self.parseDocumentsToSubmissions(documents: snapshot.documents))
            }
        completion(nil)
    }
    
    private func parseDocumentsToSubmissions(documents: [QueryDocumentSnapshot]) -> [Submissions] {
        var submissions: [Submissions] = []
        for document in documents {
            if let tournament = parseDocumentToSubmission(document: document) {
                submissions.append(tournament)
            }
        }
        return submissions
    }
    /**
     Parse `QueryDocumentSnapshot` to `Submission`
     */
    private func parseDocumentToSubmission(document: QueryDocumentSnapshot) -> Submissions? {
        if let submission = Submissions(id: document.documentID, dictionary: document.data()) {
            return submission
        } else {
            return nil
        }
    }
    

}
