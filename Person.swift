//
//  Person.swift
//  roomCronies
//
//  Created by Paul on 2017-10-20.
//  Copyright © 2017 Paul. All rights reserved.
//

import UIKit
import Parse

class Person: PFObject {
    
    @NSManaged var userName:String
    @NSManaged var userEmail:String
    @NSManaged var userPassword:String
    @NSManaged var roomName: Room
    @NSManaged var taskCreator: [Task]
    @NSManaged var taskDoer: [Task]
    
    
    //create room when person is created.
    override init() {
    super.init ()
        
    
    }
    
    
    
    
//     convenience init?(name:String, email:String, password:String, roomName:Room){
//        self.init()
//        
//        //error handling
//        guard !name.isEmpty else {
//            return nil
//        }
//        
//        guard !email.isEmpty else {
//            return nil
//        }
//        
//        guard !password.isEmpty else {
//            return nil
//        }
//        
//        
//        //Initialize stored properties
//        self.userName = name
//        self.userEmail = email
//        self.userPassword = password
//        self.roomName = roomName
//        
//        
//    }
    
    
}


//This allows the other controller to use dot notation properties.
extension Person: PFSubclassing {
    
    static func parseClassName() -> String {
        return "person"
    }
    
}

