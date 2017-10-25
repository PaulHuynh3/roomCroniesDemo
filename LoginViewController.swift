//
//  LoginViewController.swift
//  roomCronies
//
//  Created by Paul on 2017-10-24.
//  Copyright © 2017 Paul. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var roomIdentificationTextField: UITextField!
    
    private func segue(){
        performSegue(withIdentifier: "TaskViewControllerSegue", sender: nil)
    }
    
    //MARK:Life Cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        checkLoginState()
    }
    
    private func checkLoginState() {
        Person.checkUserLoginState { (success: Bool) in
            print(#line, success ? "": "not ", "auto logged in")
            if success {
                self.segue()
            }
        }
    }
    
    
    //MARK: IBActions
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let username = userNameTextField.text,
              let password = passwordTextField.text,
                  username.isEmpty == false,
                  password.isEmpty == false else {
                print("Username and Password fields cannot be empty. Please enter and try again!")
                return
        }
        Person.login(with: username, and: password) { (success: Bool, error: Error?) in
            
            guard error == nil, success == true else {
                print(#line, "not logged in")
                return
            }
            self.segue()
            
            
        }
        
}



/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */

}
