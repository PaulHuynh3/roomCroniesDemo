//
//  TaskViewCell.swift
//  roomCronies
//
//  Created by Paul on 2017-10-20.
//  Copyright © 2017 Paul. All rights reserved.
//

import UIKit
import Parse


class TaskViewCell: UITableViewCell {
    //task property being set by the roomviewcontroller row forindexpath
    var task : Task?
    
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var checkBoxComplete: CheckBox!
    @IBOutlet weak var completedByLabel: UILabel!
    
    
    
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
        task?.doneBy = PFUser.current()
        task?.doneByUsername = PFUser.current()?.username
        
        task?.saveInBackground()
        
    }
    
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func setupCell(task:Task) {
        
        taskLabel.text = task.taskName
        
        if task.doneByUsername == nil {
            completedByLabel.text = "Completed by: 🤷‍♀️ 🤷‍♂️"
        } else {
        completedByLabel.text = "Completed by"(task.doneByUsername)
        }
    }
    
    

}
