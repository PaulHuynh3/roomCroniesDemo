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
    

    var createRoom: Room?
    var listOfRoom: [Room]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        fetchExistingRoom()
        //create an instance of the room so its store in memory so you can use its properties.. createroom.roomName etc because the optional chaining.
        createRoom = Room()
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
                print(#line, "Please enter the existing room")
                return
        }
        
        
        
        //query to see if there is an existing room.
        let roomQuery = Room.query()
        roomQuery?.whereKey("roomName", equalTo: existingRoomTextField.text!)
        roomQuery?.findObjectsInBackground(block: { (results, error) in
            if let results = results as? [Room],
                let foundRoom = results.first {
                // Use the room that you found from the database
                
                
            } else {
                // Create a new room
                
                
            }
        })
        createRoom?.roomName = existingRoomTextField.text!
        
        //put this in a function
        let roomExists = listOfRoom?.contains(where: { (room) -> Bool in
            
            if createRoom?.roomName == room.roomName{
                return true
            } else {
                return false
            }
        })
        
        if roomExists == false {
            print("Existing Room does not exist. Please try again.")
            return
        }
        
        Person.signup(with: username, and: password) { (success:Bool?, error:Error?) in
            
            guard success == true else {
                print("Problems creating User!")
                return
            }
            self.performSegue(withIdentifier:"TaskViewControllerSegue", sender: nil)
        }
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue , sender: sender)
        
        guard let taskViewController = segue.destination as? TaskViewController else {
            fatalError("unexpected destination:\(segue.destination)")
        }
        //join existing room.
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
