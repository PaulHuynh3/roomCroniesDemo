//
//  Room.swift
//  roomCronies
//
//  Created by Paul on 2017-10-20.
//  Copyright © 2017 Paul. All rights reserved.
//

import UIKit
import Parse

class Room: PFObject{
    
    @NSManaged var roomName: String
    //may use this variable
    @NSManaged var owner: Person
    //many person in one room:   Person object: roomName: Room <--->> members: [Person]
    @NSManaged var members: [Person]
    //many task in one room: Task object: room: Room <--->> tasks: [Task]
    @NSManaged var tasks : [Task]
    
    
    //when the room is iniatilize in vc it will create the persons.
//    override init() {
//        super.init()
//        let paul = Person(name: "Paul", email: "paul@gmail.com", password: "password", roomName:self.roomName)
//        let jaison = Person(name: "Jaison", email: "jai@gmail.com", password:"password", roomName:self.roomName)
//        
//        
//    }
    
    
    
    
    convenience init(roomName:String,members:[Person]) {
        self.init()
        
        
        //initlize stored properties.
        self.roomName = roomName
        self.members = members
        
    }
    
    
}



//This allows the other controller to use dot notation properties.
extension Room: PFSubclassing {
    
    static func parseClassName() -> String {
        return "room"
    }
    
}
