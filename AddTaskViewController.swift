//
//  AddTaskViewController.swift
//  roomCronies
//
//  Created by Paul on 2017-10-20.
//  Copyright © 2017 Paul. All rights reserved.
//

import UIKit
import Parse

protocol AddTaskDelegate {
    
    func addTaskObject(task:Task)
}

class AddTaskViewController: UIViewController {
    
    var taskDelegate: AddTaskDelegate?
    
    //this value will either be an existing task or to create a new task
    var task: Task?
    var roomObject: Room?
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextField: UITextField!
    @IBOutlet weak var taskPriorityTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let task = task{
            
            taskNameTextField.text = task.taskName
            taskDescriptionTextField.text = task.taskDescription
            
            if var priority = Int(taskPriorityTextField.text!){
                priority = task.priority
                
            }
        }
        
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        let task = Task()
        
        
        if let name = taskNameTextField.text {
            task.taskName = name
            
        }
        
        if let description = taskDescriptionTextField.text {
            task.taskDescription = description
        }
        
        
        if let priorityNumber = Int(taskPriorityTextField.text!) {
            
            task.priority = priorityNumber
        }
        
        //the roomObject passed from the segue.
        task.room = roomObject!
        
        //relationship created with the currentUser
        guard  let currentUser = PFUser.current() else {
            // take to login screen
            navigationController?.popToRootViewController(animated: true)
            return
        }
        task.createdBy = currentUser
        
        task.saveInBackground { (success, error) in
            print(#line, success)
            print(#line, error?.localizedDescription ?? "No error saving")
        }
        
        taskDelegate?.addTaskObject(task: task)
        
        //presented modally.
        dismiss(animated: true, completion: nil)
        
        //QUERY THE ROOM AND FIND THE ARRAY OF USERS
        //ITERATE THROUGH EACH USER AND SEND NOTIFICATION USING THEIR DEVICE TOKEN
        PFCloud.callFunction(inBackground: "iosPushTest", withParameters: ["text" : "New task added - \(String(describing: taskNameTextField.text!))"])
        
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        
        //presented modally.
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    //says that this task is created by current user.
    //        task.room = PFUser.current()
    
    
    // does the query
    //        let taskQuery = PFQuery(className:"Task")
    //        if let user = PFUser.current(){
    //
    //            taskQuery.whereKey("roomOne", equalTo:user)
    //        }
    
    
    
    
}
