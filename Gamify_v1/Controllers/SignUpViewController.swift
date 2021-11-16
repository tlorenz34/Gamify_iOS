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
    
    
    @IBOutlet weak var checkButton: UIButton!
    var handle: AuthStateDidChangeListenerHandle?

    @IBOutlet weak var termsConditionsLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var termsAndConditionsButton: UIButton!
    
    var termAccepted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // emailTextField.becomeFirstResponder()
        self.setupHideKeyboardOnTap()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        
        checkButton.setImage(UIImage(systemName: "square"), for: .normal)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
 
    @IBAction func createAccount(_ sender: Any) {
        // Validation
        
        //alert user if term not accepted
        guard termAccepted == true else {
            alert(title: "Terms & Conditions", message: "Please check and accept our Terms & Conditions to continue.")
            return
        }
        
        
        // alert username has not been set
        if let username = usernameTextField.text {
            if username.count == 0 {
                alert(title: "Username", message: "Make sure you choose a username before continuing!")
                return
            }
        }
        
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
    
    
    @IBAction func acceptedTerms(_ sender: UIButton) {
        termAccepted = !termAccepted
        if (!termAccepted) {
            checkButton.setImage(UIImage(systemName: "square"), for: .normal)
        } else {
            checkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        }
    }
    
    
    @IBAction func tappedTerms(_ sender: UIButton) {
        performSegue(withIdentifier: "toTermsConditions", sender: nil)
    }
    
    
    // HELPERS
    
    func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    

}

// Extensions
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




