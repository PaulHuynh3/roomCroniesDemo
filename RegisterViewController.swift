//
//  RegisterViewController.swift
//  roomCronies
//
//  Created by Paul on 2017-10-24.
//  Copyright © 2017 Paul. All rights reserved.
//

import UIKit
import Parse

class RegisterViewController: UIViewController {
    
    //MARK: IBOulets
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var existingRoomID: UITextField!
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        //self.navigationController?.navigationBar.isTranslucent = false
    }
    //MARK: IBAction
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        
        guard let username = usernameTextField.text,
              let password = passwordTextField.text,
            username.isEmpty == false,
            password.isEmpty == false else {
                
                print("Username and Password fields cannot be empty.")
                return
        }
        
        Person.signup(with: username, and: password) { (success:Bool?, error:Error?) in
    
            guard success == true else{
                print("Problems creating User!")
                return
            }
            self.performSegue(withIdentifier: "TaskViewControllerSegue", sender: nil)
        }
    }
    
}
//    @IBAction func signUpPressed(_ sender: UIBarButtonItem) {
//
//        DataManager.signup(with: userName, and: password) { (success: Bool, error: Error?) in
//            guard success == true else {
//                self.showErrorView(error)
//                return
//            }
//            self.performSegue(withIdentifier: R.wallPicturesTableViewController, sender: nil)
//        }
//    }

    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    

