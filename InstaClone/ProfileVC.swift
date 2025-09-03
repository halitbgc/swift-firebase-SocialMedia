//
//  ProfileVC.swift
//  InstaClone
//
//  Created by Halit Bağcı on 23.08.2025.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toViewController", sender: nil)
        }
        catch {
            print("Logout Error: \(error)")
        }
    }

}
