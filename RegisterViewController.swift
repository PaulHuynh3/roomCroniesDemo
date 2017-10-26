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
    
    @IBOutlet weak var existingRoomTextField: UITextField!
    
    @IBOutlet weak var newRoomTextField: UITextField!
    
    
    var createRoom: Room?
    var listOfRoom: [Room]?

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
        createRoom = Room(roomName: existingRoomTextField.text!)
        taskViewController.myRoom = createRoom
        
        //create user with 
        guard let user = PFUser.current() else {
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
    
//Check if roomName exists.
    
    func checkRoomName (isRoom: Bool) {
        
        let roomExists = listOfRoom?.contains(where: { (room) -> Bool in
            return room == createRoom
        })

        //the return will only make it exit this function we need a parameter to make it exit the function itself.
        
        
    }
    
    
//Fetch Parse
    func fetchExistingRoom () {
        let query = PFQuery(className: "Room")
        
        query.findObjectsInBackground { (rooms:[PFObject]?, error: Error?) in
            
            if let error = error{
                print(#line, error.localizedDescription)
                return
            }
            
            guard let rooms = rooms as? [Room] else {
                return
            }
            
            self.listOfRoom = rooms
        }
        
    }
    
    
    
    
    
    
    
}




