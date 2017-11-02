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
    
    var listOfRoom: [Room]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchExistingRoom()
        navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        
        
        let backGroundColour = UIColor(red: 70, green: 132, blue: 153)
        let backGroundColour2 = UIColor(red: 153, green: 91, blue: 70)
        self.view.addGradientWithColor(topColor: backGroundColour2, bottomColor: backGroundColour)
        
        self.hideKeyboardWhenTappedAround()
        
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
        
        
        DataManager.signup(with: username, and: password) { (success:Bool?, error:Error?) in
            
            if let error = error {
                let error = R.error(with: error.localizedDescription)
                self.showErrorView(error)
            }
            
            guard success == true else {
                print("Problems creating User!")
                return
            }
            
            //creates a new room dont need to pass the room through segue b/c roomVC perform query for room associated with user logging in.
            let createRoom = Room(roomName: self.roomTextField.text!)
            
            
            guard let user = PFUser.current() else {
                return
            }
            createRoom.roomCreator = user
            createRoom.members = [user]
            createRoom.users.add(user)

            //PUSH NOTIFICATIONS - adding user to installation
            guard let installation = PFInstallation.current() else { return }
            installation["user"] = user
            installation.saveInBackground()
            
            let currentInstallation = PFInstallation.current()
            currentInstallation?.remove(forKey: "channels")
            currentInstallation?.addUniqueObject("\(String(describing: self.roomTextField.text!))", forKey: "channels")
            currentInstallation?.saveInBackground()
            
            //asynchronous call
            createRoom.saveInBackground { (success: Bool?, error: Error?) in
                if let error = error {
                    print(#line, error.localizedDescription)
                }
                guard success == true else {
                    print(#line, "not success")
                    return
                }
                //this has to be within the asynchronous call or else it will crash
                self.performSegue(withIdentifier: "TaskViewControllerSegue", sender: nil)
            }
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




