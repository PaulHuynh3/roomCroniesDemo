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
    @NSManaged var roomCreator: PFUser
    //many person in one room:   PFUser object: roomName: Room <--->> members: [PFUser]
    @NSManaged var members: [PFUser]
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
