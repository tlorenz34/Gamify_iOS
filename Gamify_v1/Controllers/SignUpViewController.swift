//
//  SignUpViewController.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 9/23/21.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // Thaddeus
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
 
    @IBAction func createAccount(_ sender: Any) {
        
        // Generic
//        let numbers: Array<Int> = [1,2,3]
//        numbers[0]
//        var name: Optional<String> = ""
//        name!
//        print(emailTextField.text) // Optional(Thaddeus)
        
        // Optionals, closure
//        UserManager.shared.create(user: User(email: emailTextField.text!), onSuccess: { errorMessage in
//            print(errorMessage)
//        })
        performSegue(withIdentifier: "toMainFeed", sender: nil)
    }
    
//    func handleSuccess(errorMessage: String?) -> Void{
//
//    }
    

}
