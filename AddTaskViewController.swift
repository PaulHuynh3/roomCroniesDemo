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
    var pickerTask = ["Expense","Non-Expense"]
    var selectedPickerExpense: String?
    //pass this in segue and connect it to the uiswitch.
    var isCompleted:Bool? = false
    
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextField: UITextField!
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var prioritySlider: UISlider!
    @IBOutlet weak var expenseTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UIPicker
        createExpensePicker()
        createToolBar()
        //Detail View
        if let task = task {
            taskNameTextField.text = task.taskName
            taskDescriptionTextField.text = task.taskDescription
            sliderLabel.text = task.priority
            expenseTextField.text = task.taskExpense
            prioritySlider.value = Float(task.priortyScale)
        }
        
    }
    
    //Mark: Action
    @IBAction func prioritySlider(_ sender: UISlider) {
        let x = Int(prioritySlider.value)
        sliderLabel.text = String(format: "%d",x)
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let name = taskNameTextField.text,
              let taskDescription = taskDescriptionTextField.text,
              let room = roomObject,
              let currentUser = PFUser.current(),
              let priorityLabel = sliderLabel.text,
              let expensePicker = selectedPickerExpense,
              let isComplete = isCompleted else {
                return
        }
        task = Task(room: room, taskName: name, description: taskDescription, priority: priorityLabel, taskExpense:expensePicker, isCompleted:isComplete, createdBy: currentUser)
        
        //priorityscale can only be set when there is an instance b/c of the optional chain.. cant set task.priortyScale under priority slider action.
        task?.priortyScale = Int(prioritySlider.value)
        
        
        task?.saveInBackground { (success, error) in
            print(#line, success)
            print(#line, error?.localizedDescription ?? "No error saving")
        }
        
        taskDelegate?.addTaskObject(task: task!)
        
        //presented modally.
        dismiss(animated: true, completion: nil)
        
        
        //MARK: push notifications
        //QUERY THE ROOM AND FIND THE ARRAY OF USERS
        //ITERATE THROUGH EACH USER AND SEND NOTIFICATION USING THEIR DEVICE TOKEN
        
        PFCloud.callFunction(inBackground: "iosPushTest", withParameters: ["text" : "\(PFUser.current()!.username!) added a new task: \(String(describing: taskNameTextField.text!))"])
        
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        
        //presented modally.
        dismiss(animated: true, completion: nil)
        
    }

}


extension AddTaskViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func createExpensePicker() {
        let expensePicker = UIPickerView()
        expensePicker.delegate = self
        //adding picker to the textfield view.
        expenseTextField.inputView = expensePicker
        
        //customizations
        expensePicker.backgroundColor = .black
    }
    
    func createToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        //customizations
        toolBar.barTintColor = .black
        toolBar.tintColor = .white
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(AddTaskViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        //picker's accessoryview
        expenseTextField.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    //customize picker label.
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label: UILabel
        
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Menlo-Regular", size: 12)
        
        label.text = pickerTask[row]
        
        return label
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerTask[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerTask.count
    }
    
    //pickerview delegate for user's selected input.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPickerExpense = pickerTask[row]
        expenseTextField.text = selectedPickerExpense
    }
    
    
}

