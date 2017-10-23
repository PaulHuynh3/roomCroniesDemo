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
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var tasks:[Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTask()
       let room = Room()
        
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
    
    func fetchTask() {
        let query = PFQuery(className: "task")
        
        //findObjectsInBackground already made a network request so we dont need to call it with a completion handler.
        
        query.findObjectsInBackground { (task:[PFObject]?, error: Error?) in
            
            //error handling
            if let error = error {
                print(#line, error.localizedDescription)
                return
            }
            
            self.tasks.append(contentsOf: task as! [Task])
            self.tableView.reloadData()
            
        }
        
        
    }
    
    
    //MARK: Create Person object & Room object
    
//    func createObject() {
//        
//        let apartment = Room()
//        
//        apartment.roomName = "imagination"
//        
//        
//        apartment.saveInBackground()
//        
//        
//        let paul = Person(name: "Paul", email: "paul@gmail.com", password: "password", roomName: apartment.objectId!)
//        let jaison = Person(name: "Jaison", email: "jai@gmail.com", password:"password", roomName: apartment.objectId!)
//        
//        apartment.members = [paul!,jaison!]
//        
//        apartment.saveInBackground()
//        paul?.saveInBackground()
//        jaison?.saveInBackground()
//        
//        self.tableView.reloadData()
//    }
    
  
    
    
    
    
}




