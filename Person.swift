//
//  Person.swift
//  roomCronies
//
//  Created by Paul on 2017-10-20.
//  Copyright © 2017 Paul. All rights reserved.

import UIKit
import Parse

class Person: PFObject, PFSubclassing {
    
    static func parseClassName() -> String {
        return "Person"
    }

    
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

