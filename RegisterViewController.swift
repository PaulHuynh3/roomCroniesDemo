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
    
    var createRoom: Room?
    
    override func viewDidLoad() {

    }
    
    //MARK: IBAction
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        
        guard let username = usernameTextField.text,
            let password = passwordTextField.text,
            let roomID = existingRoomID.text,
            username.isEmpty == false,
            password.isEmpty == false,
            roomID.isEmpty == false else {
                
                print("Username and Password fields cannot be empty.")
                return
        }
        
        Person.signup(with: username, and: password) { (success:Bool?, error:Error?) in
            
            guard success == true else {
                print("Problems creating User!")
                return
            }
            self.performSegue(withIdentifier: "TaskViewControllerSegue", sender: nil)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue , sender: sender)
        
        guard let taskViewController = segue.destination as? TaskViewController else {
            fatalError("unexpected destination:\(segue.destination)")
        }
        //creates a new room
        createRoom = Room(roomName: existingRoomID.text!)
        taskViewController.myRoom = createRoom
        
        //create user with 
        guard let user = PFUser.current() else{
            print("Error creating current user.")
            return
        }
        taskViewController.myRoom?.roomCreator = user
        taskViewController.myRoom?.members.append(user)
        
        createRoom?.saveInBackground { (success: Bool?, error: Error?) in
            print(#line, success)
            print(#line, error?.localizedDescription ?? "No error saving")
        }
        
    }
    
}




