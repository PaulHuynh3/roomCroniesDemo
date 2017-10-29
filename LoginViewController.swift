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
        
    //MARK: Life Cycle
    override func viewDidLoad() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

//        checkLoginState()
        
        navigationController?.isNavigationBarHidden = true
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "login-background.jpg")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)

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
    
    /*
     let roomQuery = Room.query()
     roomQuery?.whereKey("roomName", equalTo: existingRoomTextField.text!)
     roomQuery?.findObjectsInBackground(block: { (results, error) in
     if let results = results as? [Room],
     let foundRoom = results.first {
     
     // Use the room found from the database
     self.joinExistingRoom = foundRoom
     
     DataManager.signup(with: username, and: password) { (success:Bool?, error:Error?) in
     
     guard success == true else {
     print("Problems creating User!")
     return
     }
     guard let user = PFUser.current() else {
     print("Error creating current user.")
     return
     }
     
     self.joinExistingRoom?.members.append(user)
     
     self.joinExistingRoom?.saveInBackground { (success: Bool?, error: Error?) in
     print(#line, success)
     print(#line, error?.localizedDescription ?? "No error saving")
     if success ?? false {
     self.performSegue(withIdentifier:"TaskViewControllerSegue", sender: nil)
     }
     }
     }
     } else {
     let error = R.error(with: "Existing room does not exist. Please try again")
     self.showErrorView(error)
     }
     })
     }
 
 */
    
//    func getRoom(completion:@escaping (Room)->()) {
//        let roomQuery = Room.query()
//        guard let currentUser = PFUser.current() else { return }
//        roomQuery?.whereKey("members", equalTo: currentUser)
//        
//        roomQuery?.findObjectsInBackground(block: { (objects, error) in
//            if let error = error {
//                print(#line, error.localizedDescription)
//                return
//            }
//            guard let objects = objects else { return }
//            guard let room = objects.first as? Room else {
//                print(#line, "problems")
//                fatalError()
//            }
//            print(#line, room.roomName)
//            completion(room)
//        })
//    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue , sender: sender)
        
        switch (segue.identifier ?? "") {
            
        case "TaskViewControllerSegue":
            guard let _ = segue.destination as? TaskViewController else {
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
