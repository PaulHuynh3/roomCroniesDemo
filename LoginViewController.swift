//
//  LoginViewController.swift
//  roomCronies
//
//  Created by Paul on 2017-10-24.
//  Copyright © 2017 Paul. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var roomIdentificationTextField: UITextField!
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //        checkLoginState()
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
    
    private func segue(){
        performSegue(withIdentifier: "TaskViewControllerSegue", sender: nil)
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue , sender: sender)
        
        switch (segue.identifier ?? "") {
        case "TaskViewControllerSegue":
            guard let taskViewController = segue.destination as? TaskViewController else {
                fatalError("unexpected destination:\(segue.destination)")
            }
            
            
        case "userRegisterSegue":
            guard let registerController = segue.destination as? RegisterViewController else {
                fatalError("unexpected destination:\(segue.destination)")
            }
            
        default:
            fatalError("unexpected segue identifier \(String(describing: segue.identifier))")
            
        }
        
    }
    
    
    //MARK: Fetch Parse
    
//    func fetchExistingRooms() {
//
//
//
//    }
    
    
    
    
}
