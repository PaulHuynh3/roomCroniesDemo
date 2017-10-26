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

    
    
 
    var createRoom: Room?
    var listOfRoom: [Room]?
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchExistingRoom()
        //create an instance of the room so its store in memory so you can use its properties.. createroom.roomName etc because the optional chaining.
        createRoom = Room()
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
        
        //check if newRoomTF is empty
        //        guard let newRoomCheck = newRoomTextField.text
        //            else {
        //                print(#line, "Please enter existing room or new room name")
        //                return
        //        }
        
        
        //since this is an optional createRoom I need to create an instance of it in viewdidload
        let roomQuery = Room.query()
        roomQuery?.whereKey("roomName", equalTo: newRoomTextField.text!)
        roomQuery?.findObjectsInBackground(block: { (results, error) in
            if let results = results as? [Room],
                let foundRoom = results.first {
                // Use the room that you found from the database
                
                
            } else {
                // Create a new room
                
                
            }
        })
        createRoom?.roomName = newRoomTextField.text!
        
        //put this in a function
        let roomExists = listOfRoom?.contains(where: { (room) -> Bool in
            
            if createRoom?.roomName == room.roomName{
                return true
            } else {
                return false
            }
        })
        
        if roomExists == true {
            print("Room Name Already Exists! Please try again!")
            return
        }
        
        //check if existingRoom is empty
        //        guard let existingRoom = existingRoomTextField.text else {
        //            print(#line, "Please enter existing room or new room name")
        //            return
        //        }
        let existingRoom = existingRoomTextField.text
        
        
        
        
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
        createRoom = Room(roomName: newRoomTextField.text!)
        
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
