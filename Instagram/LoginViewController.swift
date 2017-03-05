//
//  LoginViewController.swift
//  Instagram
//
//  Created by Thomas Zhu on 3/5/17.
//  Copyright © 2017 Thomas Zhu. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        
        if let username = usernameField.text, let password = passwordField.text {
            PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) -> Void in
                if let _ = user {
                    print("You're logged in!")
                    self.performSegue(withIdentifier: "LoginSegue", sender: nil)
                } else {
                    print("User login failed.")
                    print(error?.localizedDescription ?? "Unknown error")
                }
            }
        }
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        
        // initialize a user object
        let newUser = PFUser()
        
        // set user properties
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        
        // call sign up function on the object
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if success {
                print("Yay, created a user!")
                self.performSegue(withIdentifier: "LoginSegue", sender: nil)
            } else if let error = error as? NSError {
                switch error.code {
                case 202:
                    print("User name is taken")
                default:
                    print(error.localizedDescription)
                }
            }
        }
    }
}
