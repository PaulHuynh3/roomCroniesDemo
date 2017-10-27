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
    
    @IBOutlet weak var roomTextField: UITextField!
    
    
    var createRoom: Room?
    var listOfRoom: [Room]?
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchExistingRoom()
        navigationController?.isNavigationBarHidden = false
        //self.navigationController?.navigationBar.isTranslucent = false
    }

    
    //MARK: IBAction
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        
        guard let username = usernameTextField.text,
            let password = passwordTextField.text,
            username.isEmpty == false,
            password.isEmpty == false else {
                let error = R.error(with: "Username and Password fields cannot be empty.")
                showErrorView(error)
                return
        }
        
        guard let newRoomCheck = roomTextField.text
            else {
                let error = R.error(with: "Please enter room name")
                showErrorView(error)
                return
        }
        
        //put this in a function
        let roomExists = listOfRoom?.contains(where: { (room) -> Bool in
            
            newRoomCheck == room.roomName
          
        })
        
        if roomExists == true {
            let error = R.error(with: "Room Name Already Exists! Please try again!")
            showErrorView(error)
            return
        }
        
        
        Person.signup(with: username, and: password) { (success:Bool?, error:Error?) in
            
            guard success == true else {
                print("Problems creating User!")
                return
            }
            
            //creates a new room
            self.createRoom = Room(roomName: self.roomTextField.text!)
            
            //create user with
            guard let user = PFUser.current() else {
                return
            }
            self.createRoom?.roomCreator = user
            self.createRoom?.members = [user]
            
            self.createRoom?.saveInBackground { (success: Bool?, error: Error?) in
                print(#line, success)
                print(#line, error?.localizedDescription ?? "No error saving")
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
        //pass new room taskvc.
        taskViewController.myRoom = createRoom
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




