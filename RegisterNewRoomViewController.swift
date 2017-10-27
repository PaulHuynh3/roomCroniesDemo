//
//  RegisterNewRoomViewController.swift
//  roomCronies
//
//  Created by Paul on 2017-10-26.
//  Copyright © 2017 Paul. All rights reserved.
//

import UIKit
import Parse

class RegisterNewRoomViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var existingRoomTextField: UITextField!
    

    var joinExistingRoom: Room?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
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
        
        guard let existingRoomCheck = existingRoomTextField.text
            else {
                print(#line, "Existing room can not be blank!")
                return
        }
        
        //query to see if there is an existing room.
        let roomQuery = Room.query()
        roomQuery?.whereKey("roomName", equalTo: existingRoomTextField.text!)
        roomQuery?.findObjectsInBackground(block: { (results, error) in
            if let results = results as? [Room],
                let foundRoom = results.first {
                
                // Use the room found from the database
                self.joinExistingRoom = foundRoom
                
                Person.signup(with: username, and: password) { (success:Bool?, error:Error?) in
                    
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
                print("Existing Room does not exist. Please try again.")
            }
        })
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue , sender: sender)
        
        guard let taskViewController = segue.destination as? TaskViewController else {
            fatalError("unexpected destination:\(segue.destination)")
        }
        //join existing room.
        taskViewController.myRoom = joinExistingRoom
        
    }
    
    

    
    
    
    
    
    
    
    
}
