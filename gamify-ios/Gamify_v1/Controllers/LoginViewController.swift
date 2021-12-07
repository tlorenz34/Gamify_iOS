//
//  LoginViewController.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 11/9/21.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    var userUid: String!
    
    let refreshAlert = UIAlertController(title: "User does not exist", message: "Try again.", preferredStyle: UIAlertController.Style.alert)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tappedLoginButton(_ sender: UIButton) {
        
        
        if let email = emailTextField.text, let password = passwordTextField.text{
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authResult, error) in
              guard let strongSelf = self else { return }
                if ((authResult) != nil){
                    strongSelf.performSegue(withIdentifier: "toMainFeed", sender: nil)

                } else {
                    self!.present(self!.refreshAlert, animated: true, completion: nil)


                    self!.refreshAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (action: UIAlertAction!) in
                        self!.dismiss(animated: true, completion: nil)
                    }))
                    
                }

            }
        }


    }
   
  

     
}
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // dismiss keyboard
        return true
    }
}
