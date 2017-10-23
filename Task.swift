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
    @NSManaged var taskDoer: Person
    @NSManaged var taskCreator: Person
    //maybe use it later.
    @NSManaged var dueDate: Date
    //maybe use it later.
    @NSManaged var completeDate: Date
    //many task in one room: room: Room <--->> tasks: [Task]  (Room object)
    @NSManaged var room: Room

    //use the built in property objectId to access specific object
    
    
    convenience init(taskCreator:Person, room: Room, taskName:String, description:String, isExpense:Bool, priority:Int, dueDate: Date) {
        self.init()
        
        self.taskCreator = taskCreator
        self.room = room
        self.taskName = taskName
        self.taskDescription = description
        self.isExpense = isExpense
        self.priority = priority
        self.dueDate = dueDate
    }
    
    
}



//This allows the other controller to use dot notation properties.
extension Task: PFSubclassing{
    
    static func parseClassName() -> String {
        
        return "task"
    }
    
}
