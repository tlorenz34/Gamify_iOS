//
//  IdentityManager.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 10/14/21.
//

import Foundation
import Firebase

fileprivate let KEY_IS_LOGGED_IN = "isLoggedIN"


class IdentityManager{
    static let shared = IdentityManager()
    

    private init(){}
    

    var isLoggedIn: Bool {
        
        return UserDefaults.standard.bool(forKey: KEY_IS_LOGGED_IN)
    }
    

    func signup(with identity: Identity, onComplete: @escaping (Error?, String?) -> Void) {
    
       
        Auth.auth().createUser(withEmail: identity.email, password: identity.password) { (result, error) in
            if let error = error {
                onComplete(error, nil)
                Crashlytics.crashlytics().log("Func: signUp - IdentityManager")
                return
            }
            

            UserDefaults.standard.set(true, forKey: KEY_IS_LOGGED_IN)
            

            onComplete(nil, result!.user.uid)
        }

    }
    

    func login(with identity: Identity,  onComplete: @escaping (Error?) -> Void){
        Auth.auth().signIn(withEmail: identity.email, password: identity.password) { (result, error) in
            if error == nil{
                UserDefaults.standard.set(true, forKey: KEY_IS_LOGGED_IN)
            }
            
            onComplete(error)
        }
    }
    
    

    func logout(){
        try! Auth.auth().signOut()
        UserDefaults.standard.set(false, forKey: KEY_IS_LOGGED_IN)
//        NotificationCenter.default.post(name: .Logout, object: nil)
    }
    

}
