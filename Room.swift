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
    
    
    
    convenience init(roomName:String) {
        self.init()
        
        //initlize stored properties.
        self.roomName = roomName
        
    }
    
    
}



//This allows the other controller to use dot notation properties.
extension Room: PFSubclassing {
    
    static func parseClassName() -> String {
        return "Room"
    }
    
}
