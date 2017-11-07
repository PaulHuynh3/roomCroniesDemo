//
//  TaskViewCell.swift
//  roomCronies
//
//  Created by Paul on 2017-10-20.
//  Copyright © 2017 Paul. All rights reserved.
//

import UIKit
import Parse

//need to put delegate as a "class" so i can set the delegate as a "weak var"
protocol TaskCompletedDelegate: class {
    //function doesnt have to pass anything its used to notify that the button was pressed
    func taskCompleted()
}

class TaskViewCell: UITableViewCell {
    //task property being set by the roomviewcontroller row forindexpath
    var task : Task?
    var priorityColor = [UIColor.green, UIColor.yellow, UIColor.orange, UIColor.red]
    
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var checkBoxComplete: CheckBox!
    @IBOutlet weak var completedByLabel: UILabel!
    @IBOutlet weak var priorityView: UIView!
    
    weak var delegate: TaskCompletedDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    //stays on if user selects it.
    override func layoutSubviews() {
        super.layoutSubviews()
        if let task = task {
            checkBoxComplete.isChecked = task.isCompleted
        }
    }
    
    
    //The cell already contains all the task objects because of the task.. to identify it at indexpath everything needs to be done thru the cell.
    //the correct way to do this would be to add a delegate and protocol in the cell.
    @IBAction func checkBoxTapped(_ sender: UIButton) {
        task?.isCompleted = sender.isEnabled
        //saves a reference of the pfuser
        task?.doneBy = PFUser.current()
        //ability to identify user by their name.
        task?.doneByUsername = PFUser.current()?.username
        
        PFCloud.callFunction(inBackground: "iosPushTest", withParameters: ["text" : "\(PFUser.current()!.username!) completed the task: \(String(describing: taskLabel.text!))", "channels": [PFInstallation.current()?.channels]])
        
        task?.saveInBackground(block: { (success, error) in
        
            print(#line, success)
            print(#line, error?.localizedDescription ?? "No error saving")
            
            
            //delegate doesnt have to pass anything it just tells the view controller that the checkbox was tapped and its completed. In the RoomViewController it will have a delegate that receives the information and will have function to run when it happens in roomviewcontroller.
            self.delegate?.taskCompleted()
            
        })
    }
    
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupCell(task:Task) {
        
        taskLabel.text = task.taskName
        
        if task.doneByUsername == nil {
            completedByLabel.text = "Completed by: 🤷‍♀️ 🤷‍♂️"
        } else {
            completedByLabel.text = "Completed by: " + task.doneByUsername! + " 🙌"
        }
        
         priorityView.backgroundColor = priorityColor[task.priority]
        
    }
    
    

}
