//
//  DataManager.swift
//  roomCronies
//
//  Created by Paul on 2017-10-27.
//  Copyright © 2017 Paul. All rights reserved.
//

import Foundation
import Parse

class DataManager  {
    //retrieve the room or create a room that is related to the current user
    static func getRoom(completion:@escaping (Room)->()) {
        guard let currentUser = PFUser.current() else { return }
        let roomQuery = Room.query()
        
        roomQuery?.whereKey("members", equalTo: currentUser)
        
        roomQuery?.findObjectsInBackground(block: { (objects, error) in
            if let error = error {
                print(#line, error.localizedDescription)
                return
            }
            guard let objects = objects else { return }
            guard let room = objects.first as? Room else {
                print(#line, "problems")
                fatalError()
            }
            print(#line, room.roomName)
            
            //PUSH NOTIFICATIONS - adding user to installation
            guard let user = PFUser.current() else { return }
            guard let installation = PFInstallation.current() else { return }
            installation["user"] = user
            installation.saveInBackground()
            
            let currentInstallation = PFInstallation.current()
//            currentInstallation?.remove(forKey: "channels")
//            currentInstallation?.addUniqueObject("\(room.roomName)", forKey: "channels")
            currentInstallation?.channels = [room.roomName]
            currentInstallation?.saveInBackground()
            

            
            completion(room)
        })
    }
    
    //automatically log user in
    static func checkUserLoginState(completion:(Bool) -> Void) {
        completion(PFUser.current()?.isAuthenticated ?? false)
    }
    
    static func login(with userName: String, and password: String, completion:@escaping (Bool, Error?)-> Void) {
        PFUser.logInWithUsername(inBackground: userName, password: password) { user, error in
            guard let _ = user else {
                completion(false, error)
                return
            }
            completion(true, nil)
        }
    }
    
    static func signup(with userName: String, and password: String, completion: @escaping (Bool, Error?)-> Void) {
        let user = PFUser()
        user.username = userName
        user.password = password
        user.signUpInBackground { success, error in
            completion(success, error)
        }
    }
    
    
    
    
}
