//
//  TaskViewController.swift
//  roomCronies
//
//  Created by Paul on 2017-10-20.
//  Copyright © 2017 Paul. All rights reserved.
//

import UIKit
import Parse

class TaskViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddTaskDelegate {
// created an instance of this property this way will create your property before viewdidload
//    lazy var myRoom = Room(roomName: "car")
//this tells you to create an initializer without putting "?" on room because its created before view did load.
    var myRoom : Room?
    
    @IBOutlet weak var tableView: UITableView!
    
    var tasks:[Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRoomRelatedTask()
        
        //create an instance of a room in viewdidload so it will stay the same except everytime the user clicks start... This should be when the user creates the login page
//        myRoom = Room(roomName: "StoryBook")
        
    }
    
    
    
    //MARK: Tableview Datasource
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return tasks.count
        
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cellIdentifier = "TaskViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TaskViewCell else {
            
            fatalError("The dequeued cell is not TaskViewCell")
            
        }
        
        let task = tasks[indexPath.row]
        
        cell.setupCell(task: task)
        
        
        return cell
        
    }
    
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
        case "AddTaskSegue":
            
            guard let addTaskVC = segue.destination as? AddTaskViewController else{
                fatalError("unexpected destination:\(segue.destination)")
            }
            //pass the roomObject to addTask
            //assigning the property to the room object created in viewdidload.
            addTaskVC.roomObject = myRoom
            
            
            //set to be the task delegate
            addTaskVC.taskDelegate = self
            
            print("Adding a new task")
            
        case "ShowDetailTask":
            
            guard let detailedTaskVc = segue.destination as? AddTaskViewController else {
                fatalError("unexpected destination:\(segue.destination)")
            }
            guard let taskViewCell = sender as? TaskViewCell else {
                fatalError("unexpected sender:\((String)(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: taskViewCell) else {
                fatalError("The selected cell is not being displayed by the table")
                
            }
            
            let selectedTask = tasks[indexPath.row]
            detailedTaskVc.task = selectedTask
            
        default:
            fatalError("unexpected segue identifier \(String(describing: segue.identifier))")
        }
    }
    
    
    
    //MARK: Task Delegate
    func addTaskObject(task: Task) {
        
        tasks.append(task)
        self.tableView.reloadData()
        
    }
    
    
    //MARK: Fetch Parse
    
    func fetchRoomRelatedTask() {
        let query = PFQuery(className: "Room")

        //findObjectsInBackground already made a network request so we dont need to call it with a completion handler.
        
        query.findObjectsInBackground { (rooms:[PFObject]?, error: Error?) in
            
            //error handling
            if let error = error {
                print(#line, error.localizedDescription)
                return
            }
            
            guard let rooms = rooms as? [Room] else { return }
            //fetch the first room.
            //In the future this will need to be configure for which room or rooms to fetch.
            //rooms is an array but rooms.first gives the first element so its fine.
            self.myRoom = rooms.first
            
            //fetching all the task associated with the room.
            self.fetchTaskByRoom()
            
        }
        
    }
    
    //fetch specific task created by specific room ID
    func fetchTaskByRoom() {
        let taskQuery = PFQuery(className: "Task")
        taskQuery.order(byAscending: "taskName")
        
        //fetch room by its variable.
        taskQuery.whereKey("room", equalTo: self.myRoom)
        
        
        //temp way to fetch room.
//        taskQuery.whereKey("room", equalTo: PFObject(withoutDataWithClassName:"Room", objectId: "ogro8r3MMC"))
        
        taskQuery.findObjectsInBackground { (task:[PFObject]?, error: Error?) in
            
            //error handling
            if let error = error {
                print(#line, error.localizedDescription)
                return
            }
            
            //currently adding all PFObjects no matter if they are associated with the room.
            //add condition to make it only add specific ones.
//            if myRoom.objectId = "Va0wayaQBg" {
                self.tasks.append(contentsOf: task as! [Task])
//            }
            self.tableView.reloadData()
        }
        
    }
    
    
    
    //    func fetchAllTask() {
    //        let query = PFQuery(className: "Task")
    //
    //        //findObjectsInBackground already made a network request so we dont need to call it with a completion handler.
    //
    //        query.findObjectsInBackground { (task:[PFObject]?, error: Error?) in
    //
    //            //error handling
    //            if let error = error {
    //                print(#line, error.localizedDescription)
    //                return
    //            }
    //
    //            self.tasks.append(contentsOf: task as! [Task])
    //            self.tableView.reloadData()
    //
    //        }
    //
    //    }

    
    
    
    
}




