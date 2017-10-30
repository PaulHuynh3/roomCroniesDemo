//
//  TaskViewController.swift
//  roomCronies
//
//  Created by Paul on 2017-10-20.
//  Copyright © 2017 Paul. All rights reserved.
//

import UIKit
import Parse

class RoomViewController: UIViewController {
    //created before viewdidload therefore requires "?"
    var myRoom : Room? = nil {
        didSet {
            //when login viewdidload may load before it gets set.
            fetchTaskByRoom()
        }
    }
    var tasks: [Task] = []
    //might get rid of this.
    var selectedIndexPath: IndexPath?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //fetches the room related to the user.
        DataManager.getRoom(completion: {[unowned self] (room) in
            self.myRoom = room
            
            
        })
        navigationController?.isNavigationBarHidden = false
        let backgroundImage = UIImage(named: "iphone-3.jpg")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
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
            guard let myRoom = myRoom else {
                return
            }
            addTaskVC.roomObject = myRoom
            
            //set to be the task delegate
            addTaskVC.taskDelegate = self
            
            print("Adding a new task")
            
        case "ShowDetailTask":
            
            guard let detailedTaskVc = segue.destination as? AddTaskViewController else {
                fatalError("unexpected destination:\(segue.destination)")
            }
            guard let roomViewCell = sender as? RoomViewCell else {
                fatalError("unexpected sender:\((String)(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: roomViewCell) else {
                fatalError("The selected cell is not being displayed by the table")
                
            }
            
            let selectedTask = tasks[indexPath.section]
            detailedTaskVc.task = selectedTask
            
        default:
            fatalError("unexpected segue identifier \(String(describing: segue.identifier))")
        }
    }
    
    //MARK: IBAction
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        PFUser.logOut()
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func taskCompleteToggled(_ sender: UISwitch) {
        
        let task = Task()
        
        //set button tags for each of the selected button.
        
        
        //query for existinh tasks if the list of task matches the task being checked by the user. Add "doneBy" and move the task into a "completed" tableview
        
        //need to indicate the selected cell for indexpath or it will save as a new object.
        if selectedIndexPath?.row != nil {
            task.doneBy = PFUser.current()
            
            
            task.saveInBackground { (success:Bool, error:Error?) in
                print(#line, success)
                print(#line, error?.localizedDescription ?? "error in saving")
            }
        }
    }
    
    //might not need this function
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndexPath = indexPath
        print(#line, selectedIndexPath)
    }
    
    
    //MARK: Fetch Parse
    func fetchTaskByRoom() {
        let taskQuery = PFQuery(className: "Task")
        taskQuery.order(byAscending: "taskName")
        
        //fetch room by its set variable above.
        guard let myRoom = self.myRoom else {
            return
        }
        
        taskQuery.whereKey("room", equalTo: myRoom)
        
        taskQuery.findObjectsInBackground { (result: [PFObject]?, error: Error?) in
            
            //error handling
            if let error = error {
                print(#line, error.localizedDescription)
                return
            }
            
            //return the statement before it actually fetches (if there is no task it will just return)
            guard let result = result as? [Task] else { return }
            
            //dont append tasks. just set it to equal the array to display all the tasks.
            self.tasks = result
            self.tableView.reloadData()
        }
        
    }
    
}

extension RoomViewController: UITableViewDelegate, UITableViewDataSource{
    
    //MARK: Tableview Datasource
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.tasks.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
        
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cellIdentifier = "RoomViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RoomViewCell else {
            
            fatalError("The dequeued cell is not RoomViewCell")
        }
        
        let createTask = tasks[indexPath.section]
        
        
        cell.setupCell(task: createTask)
        //cell.contentView.backgroundColor = UIColor.clear;
        cell.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = true
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
}

extension RoomViewController: AddTaskDelegate{
    
    func addTaskObject(task: Task) {
        
        tasks.append(task)
        self.tableView.reloadData()
        
    }
    
}

