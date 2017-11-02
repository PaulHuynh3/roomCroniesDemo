//
//  RegisterNewRoomViewController.swift
//  roomCronies
//
//  Created by Paul on 2017-10-26.
//  Copyright © 2017 Paul. All rights reserved.
//

import UIKit
import Parse

class ExistingRoomViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var existingRoomTextField: UITextField!
    
    
    var joinExistingRoom: Room?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        
//        let backGroundColour = UIColor(red: 70, green: 132, blue: 153)
//        self.view.addGradientWithColor(topColor: backGroundColour, bottomColor: .white)

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "blurred1")!)
        
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
        
        guard let existingRoomCheck = existingRoomTextField.text
            else {
                let error = R.error(with: "Existing room can not be blank!")
                showErrorView(error)
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
                
                DataManager.signup(with: username, and: password) { (success:Bool?, error:Error?) in
                    
                    guard success == true else {
                        let error = R.error(with: (error?.localizedDescription)!)
                        self.showErrorView(error)
                        return
                    }
                    guard let user = PFUser.current() else {
                        return
                    }
                    
                    self.joinExistingRoom?.members.append(user)
                    self.joinExistingRoom?.users.add(user)
                    
                    let currentInstallation = PFInstallation.current()
                    currentInstallation?.remove(forKey: "channels")
                    currentInstallation?.addUniqueObject("\(String(describing: self.existingRoomTextField.text!))", forKey: "channels")
                    currentInstallation?.saveInBackground()
                    
                    
                    // self.joinExistingRoom?.users.query()
                    
                    self.joinExistingRoom?.saveInBackground { (success: Bool?, error: Error?) in
                        print(#line, success)
                        print(#line, error?.localizedDescription ?? "No error saving")
                        if success ?? false {
                            //this has to be in the block (asynchronous call)
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


    
    
    
    
    
    
    
    
    
    
    
}

