//
//  LoginViewController.swift
//  Instagram
//
//  Created by Thomas Zhu on 3/5/17.
//  Copyright © 2017 Thomas Zhu. All rights reserved.
//

import UIKit
import Parse
import PKHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: LoginTextField!
    @IBOutlet weak var passwordField: LoginTextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.cornerRadius = 20
        loginButton.clipsToBounds = true
        
        registerButton.layer.cornerRadius = 20
        registerButton.clipsToBounds = true
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        if let username = usernameField.text, let password = passwordField.text {
            HUD.show(.progress)
            
            PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) -> Void in
                if let _ = user {
                    HUD.hide(animated: true)
                    self.performSegue(withIdentifier: "LoginSegue", sender: nil)
                } else {
                    HUD.flash(.error)
                    print(error?.localizedDescription ?? "Unknown error")
                }
            }
        }
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        
        HUD.show(.progress)
        
        // initialize a user object
        let newUser = PFUser()
        
        // set user properties
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        
        // call sign up function on the object
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if success {
                HUD.hide(animated: true)
                self.performSegue(withIdentifier: "LoginSegue", sender: nil)
            } else if let error = error as? NSError {
                HUD.flash(.error)
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
