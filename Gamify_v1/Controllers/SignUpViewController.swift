//
//  SignUpViewController.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 9/23/21.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    var handle: AuthStateDidChangeListenerHandle?

    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // emailTextField.becomeFirstResponder()
        self.setupHideKeyboardOnTap()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        
    }
    


    
    
 
    @IBAction func createAccount(_ sender: Any) {
        // Validation
        
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
            
            let user = User(id: uid, email: identity.email, username: self.usernameTextField.text!)
            UserManager.shared.create(user: user) { errorMessage in
                if let errorMessage = errorMessage{
                    print(errorMessage)
                    return
                }
                
                self.performSegue(withIdentifier: "MainFeedSegue", sender: nil)
            }
        }
        
    }
    
    @IBAction func tappedLogin(_ sender: UIButton) {
        performSegue(withIdentifier: "toLogin", sender: nil)
    }
    @IBAction func unwindToSignUp(_ sender: UIStoryboardSegue){}

    
    

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
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // dismiss keyboard
        return true
    }
}




