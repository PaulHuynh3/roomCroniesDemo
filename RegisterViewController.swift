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
    
    @IBOutlet weak var signUpPicture: UIImageView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    var listOfRoom: [Room]?
    
    var imageArray: [UIImage] = [
        UIImage(named: "signup1.png")!,
        UIImage(named: "signup2.png")!,
        UIImage(named: "signup3.png")!        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchExistingRoom()
        navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        

        //navigationItem.title = ""
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "blurred2")!)
        
        
//        let backGroundColour = UIColor(red: 70, green: 132, blue: 153)
//        let backGroundColour2 = UIColor(red: 153, green: 91, blue: 70)
//        self.view.addGradientWithColor(topColor: backGroundColour2, bottomColor: backGroundColour)
        
        usernameTextField.underlined()
        passwordTextField.underlined()
        roomTextField.underlined()
        
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Create a new username",
                                                                     attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Create a new password",
                                                                     attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        roomTextField.attributedPlaceholder = NSAttributedString(string: "Create a new room",
                                                                     attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        self.signUpPicture.animationImages = imageArray;
        self.signUpPicture.animationDuration = 3.0
        self.signUpPicture.startAnimating()
        
        self.blurView.layer.cornerRadius = 35
        self.blurView.clipsToBounds = true

        
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
                self.performSegue(withIdentifier: "RoomViewControllerSegue", sender: nil)
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




