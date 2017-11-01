//
//  RoomViewController.swift
//  roomCronies
//
//  Created by Paul on 2017-10-20.
//  Copyright © 2017 Paul. All rights reserved.


import UIKit
import Parse

class RoomViewController: UIViewController {
    //created before viewdidload therefore requires "?"
    var myRoom : Room? = nil {
        didSet {
            //viewdidload may load before it gets set.
            fetchIncompleteNonExpenseTask()
        }
    }
    var tasks: [Task] = []
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //fetches the room related to the user.
        DataManager.getRoom(completion: {[unowned self] (room) in
            self.myRoom = room
        })
        refreshUserScreen()
        
        //put in a function
        navigationController?.isNavigationBarHidden = false
        let backgroundImage = UIImage(named: "iphone-3.jpg")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
    }
    
    //MARK: Refresh Screen
    func refreshUserScreen(){
        
        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.orange
        refreshControl.tintColor = UIColor.white
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action:#selector(RoomViewController.refresh(sender:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }

    func refresh(sender:UIRefreshControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.fetchIncompleteNonExpenseTask()
            refreshControl.endRefreshing()
            
        case 1:
            self.fetchIncompleteExpenseTask()
            refreshControl.endRefreshing()

        case 2:
            self.fetchCompletedTask()
            refreshControl.endRefreshing()

        default:
            break
        }
        
    }
    
    //MARK: Segmented Control.
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            
            print("Show task")
            self.fetchIncompleteNonExpenseTask()
            
        case 1:
            print("Show expense task")
            self.fetchIncompleteExpenseTask()
            
        case 2:
            print("show completed task and expense")
            self.fetchCompletedTask()
            
        default:
            print("Segmented Control error. Button not selected")
            break
        }
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
            guard let taskViewCell = sender as? TaskViewCell else {
                fatalError("unexpected sender:\((String)(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: taskViewCell) else {
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
    
    
    
    //MARK: Fetch Parse
    
    func fetchIncompleteExpenseTask() {
        
        let query = PFQuery(className:"Task")
        
        guard let myRoom = self.myRoom else{return}
        
        query.whereKey("room", equalTo: myRoom)
        query.whereKey("isCompleted", equalTo: false)
        query.whereKey("taskExpense", equalTo:"Expense")
        
        query.findObjectsInBackground { (results: [PFObject]?, error: Error?) in
            
            if let error = error {
                print(#line, error.localizedDescription)
            }
            
            guard let results = results as? [Task] else {return}
            
            self.tasks = results
            self.tableView.reloadData()
            
        }
        
    }
    
    //fetch all room's completed task and expense and add this to tab bar completed.
    func fetchCompletedTask() {
        
        let query = PFQuery(className: "Task")
        
        guard let myRoom = self.myRoom else{return}
        
        query.whereKey("room", equalTo: myRoom)
        query.whereKey("isCompleted", equalTo: true)
        
        query.findObjectsInBackground { (results: [PFObject]?, error: Error?) in
            
            if let error = error {
                print(#line, error.localizedDescription)
            }
            
            guard let results = results as? [Task] else {return}
            
            self.tasks = results
            self.tableView.reloadData()
        }
    }
    
    //use this filter it with expense and non-expense items.
    func fetchIncompleteNonExpenseTask() {
        
        let query = PFQuery(className: "Task")
        
        guard let myRoom = self.myRoom else{return}
        
        query.whereKey("room", equalTo: myRoom)
        query.whereKey("isCompleted", equalTo: false)
        query.whereKey("taskExpense", equalTo: "Non-Expense")
        
        query.findObjectsInBackground { (results: [PFObject]?, error: Error?) in
            
            if let error = error {
                print(#line, error.localizedDescription)
            }
            
            guard let results = results as? [Task] else {return}
            
            self.tasks = results
            self.tableView.reloadData()
            
        }
        
    }
    
}

extension RoomViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Tableview Datasource
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.tasks.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
        
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cellIdentifier = "TaskViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TaskViewCell else {
            
            fatalError("The dequeued cell is not TaskViewCell")
        }
        
        let createTask = tasks[indexPath.section]
        //access a task in the task list.. this is used for all TASK object's anything in the indexpath.. including the customize button. The task object is the whole and the properties are part of the object
        //this sets the task property in cell.
        cell.task = tasks[indexPath.section]
        
        cell.setupCell(task: createTask)
        //cell.contentView.backgroundColor = UIColor.clear;
        cell.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = true
        
        return cell
    }
    
    //delete functionality for heroku and on tableview.
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            //delete the task object from parse. The tasks are already being fetched
            var taskCloud = PFObject(className: "Task")
            taskCloud = tasks[indexPath.section] as PFObject
            
            taskCloud.deleteInBackground(block: { (success:Bool?, error:Error?) in
                
                if error == nil{
                    
                    // Delete the row locally from tableview
                    self.tasks.remove(at: indexPath.section)
                    self.tableView.deleteSections([indexPath.section], with: .fade)
                    print("Delete Success")
                } else {
                    print("Failed to delete")
                }
                
            })

        }
        
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

