//
//  ViewController.swift
//  InstaClone
//
//  Created by Halit Bağcı on 23.08.2025.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func signInClicked(_ sender: Any) {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if email == "" || password == "" {
            makeAlert(title: "Error", message: "email veya password boş bırakılamaz!")
            return
        }
        
        Auth.auth().signIn(withEmail: email!, password: password!) { authResult, error in
            if error != nil {
                self.makeAlert(title: "Error", message: error!.localizedDescription)
            }
            else {
                self.performSegue(withIdentifier: "toFeed", sender: nil)
            }
        }
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if email == "" || password == "" {
            makeAlert(title: "Error", message: "email veya password boş bırakılamaz!")
            return
        }
        
        Auth.auth().createUser(withEmail: email!, password: password!) { authResult, error in
            if error != nil {
                self.makeAlert(title: "Error", message: error!.localizedDescription)
            }
            else {
                self.performSegue(withIdentifier: "toFeed", sender: nil)
            }
        }
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

