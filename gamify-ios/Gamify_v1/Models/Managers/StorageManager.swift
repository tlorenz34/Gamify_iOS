//
//  StorageManager.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 10/5/21.
//

import Foundation
import Firebase

class StorageManager{
    static let shared = StorageManager()
    
    let storage = Storage.storage()
    
    
//    func upload(path: String, data: Data, onSuccess: @escaping (URL) -> Void ){
//        let ref = storage.reference().child(path)
//
//        ref.putData(data, metadata: nil) { metedata, error in
//
//            if let error = error{
//                print(error)
//                return
//            }
//
//            ref.downloadURL { url, error in
//                if let error = error{
//                    print(error)
//                    return
//                }
//
//                if let url = url{
//                    onSuccess(url)
//                }
//            }
//        }
//    }
    
}
