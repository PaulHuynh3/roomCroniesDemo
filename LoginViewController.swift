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
    
    @IBOutlet weak var backView: UIView!
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        checkLoginState()
        
        navigationController?.isNavigationBarHidden = true
        
        let backGroundColour = UIColor(red: 70, green: 132, blue: 153)
        let backGroundColour2 = UIColor(red: 153, green: 91, blue: 70)
        self.view.addGradientWithColor(topColor: backGroundColour, bottomColor: backGroundColour2)
        
    }
    
    private func checkLoginState() {
        DataManager.checkUserLoginState { (success: Bool) in
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
             let error = R.error(with: "Username and Password fields cannot be empty. Please enter and try again!")
                showErrorView(error)
                return
        }
        DataManager.login(with: username, and: password) { (success: Bool, error: Error?) in
            
            if let error = error {
              let error = R.error(with: error.localizedDescription)
                self.showErrorView(error)
            }
            
            guard error == nil, success == true else {
                print(#line, "not logged in")
                return
            }
            self.segue()
        }
    }
    
    private func segue(){
        // TaskViewControllerSegue
        performSegue(withIdentifier: "TaskViewControllerSegue", sender: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue , sender: sender)
        
        switch (segue.identifier ?? "") {
            //dont need to pass anything through segue. taskVC does a query for existing user and fetches the tasks.
        case "TaskViewControllerSegue":
            guard let _ = segue.destination as? RoomViewController else {
                print(#line, "unexpected destination:\(segue.destination)")
                return
            }
            
        case "userRegisterSegue":
            guard let registerController = segue.destination as? RegisterViewController else {
                fatalError("unexpected destination:\(segue.destination)")
            }
        case "createNewRoomSegue":
            guard let createNewRoomController = segue.destination as? ExistingRoomViewController else {
                 fatalError("unexpected destination:\(segue.destination)")
            }
            
        default:
            fatalError("unexpected segue identifier \(String(describing: segue.identifier))")
            
        }
        
    }
    
    
    
  
    
    
    
    
    
}
