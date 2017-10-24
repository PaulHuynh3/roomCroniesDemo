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
        
        //the property passed from the segue.
        task.room = roomObject!
        
        
        task.saveInBackground { (success, error) in
            print(#line, success)
            print(#line, error?.localizedDescription ?? "No error saving")
        }
        
        
        taskDelegate?.addTaskObject(task: task)
        
        //presented modally.
        dismiss(animated: true, completion: nil)
        
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
