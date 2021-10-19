//
//  SignUpViewController.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 9/23/21.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // emailTextField.becomeFirstResponder()
        self.setupHideKeyboardOnTap()

        
    }
    
 
    @IBAction func createAccount(_ sender: Any) {
        let identity = Identity(email: emailTextField.text!, password: passwordTextField.text!)
        
        IdentityManager.shared.signup(with: identity) { err, uid in
            if let err = err{
                print(err)
                return
            }
            guard let uid = uid else {
                print("no user id")
                return
            }
            
            let user = User(id: uid, email: identity.email)
            UserManager.shared.create(user: user) { errorMessage in
                if let errorMessage = errorMessage{
                    print(errorMessage)
                    return
                }
                
                self.performSegue(withIdentifier: "MainFeedSegue", sender: nil)
            }
        }
        
    }
    
    
    

}
extension UIViewController {
    /// Call this once to dismiss open keyboards by tapping anywhere in the view controller
    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }

    /// Dismisses the keyboard from self.view
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
}



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

//    func handleSuccess(errorMessage: String?) -> Void{
//
//    }
