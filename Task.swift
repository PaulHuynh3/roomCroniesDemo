//
//  Task.swift
//  roomCronies
//
//  Created by Paul on 2017-10-20.
//  Copyright © 2017 Paul. All rights reserved.
//

import UIKit
import Parse

class Task: PFObject {
    @NSManaged var taskName : String
    @NSManaged var taskDescription: String
    @NSManaged var isExpense: Bool
    @NSManaged var priority: Int
    //many task in one room: room: Room <--->> tasks: [Task]  (Room object)
    @NSManaged var room: Room
    //one to many.. one user can make multiple task
    @NSManaged var createdBy: PFUser
    //when user checks off a task. it will be.. doneBy.currentUser..
    @NSManaged var doneBy: PFUser?

    //use the built in property objectId to access specific object
    
    
    convenience init(room: Room, taskName:String, description:String, isExpense:Bool, priority:Int, createdBy: PFUser) {
        self.init()
        self.room = room
        self.taskName = taskName
        self.taskDescription = description
        self.isExpense = isExpense
        self.priority = priority
        self.createdBy = createdBy
    }
    
}



//This allows the other controller to use dot notation properties.
extension Task: PFSubclassing{
    
    static func parseClassName() -> String {
        
        return "Task"
    }
    
}
