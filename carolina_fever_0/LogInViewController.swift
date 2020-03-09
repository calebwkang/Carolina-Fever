//
//  LogInViewController.swift
//  carolina_fever_0
//
//  Created by Caleb Kang on 7/25/19.
//  Copyright © 2019 Caleb Kang. All rights reserved.
//

import UIKit
import Parse

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    @IBOutlet var pidField: UITextField!
    @IBOutlet var passField: UITextField!
    @IBOutlet var checkLogButton: UIButton!
    @IBOutlet var switchLabel: UILabel!
    @IBOutlet var switchButton: UIButton!
    
    // MARK: Variables
    var isSignUp = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        
        if PFUser.current() != nil {
            performSegue(withIdentifier: "toDash", sender: self)
        }
    }

    // MARK: Actions
    
    /*handles when the user is ready to log in and check points**/
    @IBAction func checkPointsPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if isSignUp {
            let user = PFUser()
            user.username = pidField.text
            user.password = passField.text
            
            if let pid = Int(pidField.text!) {
                user["pid"] = NSNumber(value: pid)
                user["isTop150"] = false
                
                let games = [Game]() as NSArray
                user["games"] = games
                
                
                user.signUpInBackground { (succeeded: Bool, error: Error?) in
                    if succeeded {
                        print("You are signed up!")
                        self.performSegue(withIdentifier: "toDash", sender: self)
                    } else {
                        print(error!)
                    }
                }
            }
            
        } else {
            
            PFUser.logInWithUsername(inBackground: pidField.text!, password: passField.text!) { (user: PFUser?, error: Error?) in
                if user != nil {
                    // Log in Successful
                    self.performSegue(withIdentifier: "toDash", sender: self)
                    
                } else {
                    // The login failed. Check error to see why.
                    print(error!)
                }
            }
        }
    }
    
    /*this method codes functionality to allow user to switch
     between logging and signing up**/
    @IBAction func switchPressed(_ sender: Any) {
        
        if isSignUp {
            /*switch to log in mode*/
            isSignUp = false
            checkLogButton.setTitle("Log In", for: [])
            
            /*give user option to switch back to Sign up mode*/
            switchButton.setTitle("Sign Up", for: [])
            
            switchLabel.text = "You a New User?"
            
        } else {
            /*switch to sign up mode*/
            isSignUp = true
            checkLogButton.setTitle("Sign Up", for: [])
            
            /*give user option to switch back to log in mode*/
            switchButton.setTitle("Log In", for: [])
            switchLabel.text = "Already signed up?"
        }
        
    }
    
    // MARK: Text Field Delgate
    
    /* *****closes text field when user presses return***** */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pidField.resignFirstResponder()
        return true
    }
    
    /* *****closes text field when user taps outside keyboard***** */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
