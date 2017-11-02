//
//  AddTaskViewController.swift
//  roomCronies
//
//  Created by Paul on 2017-10-20.
//  Copyright © 2017 Paul. All rights reserved.
//

import UIKit
import Parse

protocol AddTaskDelegate: class {
    
    func addTaskObject(task:Task)
}

class AddTaskViewController: UIViewController, UITextViewDelegate {
    
    weak var taskDelegate: AddTaskDelegate?
    
    //this value will either be an existing task or to create a new task
    var task: Task?
    var roomObject: Room?
    var pickerTask = ["","Expense","Task"]
    var priorityColor = [UIColor.green, UIColor.yellow, UIColor.orange, UIColor.red]
    var selectedPickerExpense: String?
    //set it as incomplete. So we can query for incomplete tasks.
    var isCompleted:Bool? = false
    
    @IBOutlet weak var addTaskNavigationBar: UINavigationBar!
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextView: UITextView!
    var placeholderLabel : UILabel!
    
    @IBOutlet weak var priorityLevelView: UIView!
    @IBOutlet weak var expenseTextField: UITextField!
    
      //Detail View will see this.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.addTaskNavigationBar.tintColor = UIColor.white
        
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.addTaskNavigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        
        taskNameTextField.underlined()
        expenseTextField.underlined()
        
        taskNameTextField.attributedPlaceholder = NSAttributedString(string: "Enter a task or expense here...",
                                                                     attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        expenseTextField.attributedPlaceholder = NSAttributedString(string: "Is it an expense or task?",
                                                                     attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        taskDescriptionTextView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Enter your description..."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (taskDescriptionTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        taskDescriptionTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (taskDescriptionTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.white
        placeholderLabel.isHidden = !taskDescriptionTextView.text.isEmpty
        textViewDidChange(taskDescriptionTextView)
        
        
        
        
        self.addTaskNavigationBar.setBackgroundImage(UIImage(), for: .default)
        self.addTaskNavigationBar.shadowImage = UIImage()
        self.addTaskNavigationBar.isTranslucent = true
        

        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "blurred8")?.draw(in: self.view.bounds)
        
        if let image = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
        }else{
            UIGraphicsEndImageContext()
            debugPrint("Image not available")
        }
        
        //textview layout
        taskDescriptionTextView.layer.borderColor = UIColor.black.cgColor
        taskDescriptionTextView.layer.borderWidth = 1.0
        
        //priority layout
        priorityLevelView.backgroundColor = UIColor.green
        priorityLevelView.layer.cornerRadius = priorityLevelView.bounds.size.width/2
        
        //programatically add the tap gesture.
        //set the firstcolour as green so when the function loops its able to find it.
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        priorityLevelView.addGestureRecognizer(tap)
        
        //UIPicker
        createExpensePicker()
        createToolBar()
        
        if let task = task {
            taskNameTextField.text = task.taskName
            taskDescriptionTextView.text = task.taskDescription
            expenseTextField.text = task.taskExpense
            priorityLevelView.backgroundColor = priorityColor[task.priority]
        }
        self.hideKeyboardWhenTappedAround() 
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !taskDescriptionTextView.text.isEmpty
    }
    
    
    //Mark: Action
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let name = taskNameTextField.text,
              let taskDescription = taskDescriptionTextView.text,
              let room = roomObject,
              let currentUser = PFUser.current(),
              let priorityView = priorityLevelView.backgroundColor,
              let expensePicker = selectedPickerExpense,
              let isComplete = isCompleted,
              name.isEmpty == false,
              taskDescription.isEmpty == false else {
                let error = R.error(with: "Fill out all information! 😠")
                showErrorView(error)
                return
        }
        task = Task(room: room, taskName: name, description: taskDescription, taskExpense:expensePicker, isCompleted:isComplete, createdBy: currentUser)
        
        
        
        //change the background color.
        guard let priority =  priorityColor.index(of: priorityView) else { return }
        task?.priority = priorityColor.startIndex.distance(to: priority)
        
        task?.saveInBackground {[unowned self] (success, error) in
            print(#line, success)
            print(#line, error?.localizedDescription ?? "No error saving")
            PFCloud.callFunction(inBackground: "iosPushTest", withParameters: ["text" : "\(PFUser.current()!.username!) added a new task: \(String(describing: self.taskNameTextField.text!))", "channels": [PFInstallation.current()?.channels]])
            self.taskDelegate?.addTaskObject(task: self.task!)
            
            //presented modally.
            self.dismiss(animated: true, completion: nil)
        }
        
        
        
        
        //MARK: push notifications
        //QUERY THE ROOM AND FIND THE ARRAY OF USERS
        //ITERATE THROUGH EACH USER AND SEND NOTIFICATION USING THEIR DEVICE TOKEN
        
     
//        let text = "\(PFUser.current()!.username!) added a new task: \(String(describing: taskNameTextField.text!))";
//        let data = [
//            "badge" : "Increment",
//            "alert" : text,
//            ]
//        let request: [String : Any] = [
//            //"someKey" : PFUser.current()!.deviceToken,
//            "someKey" : PFUser.current()!.objectId!,
//            "data" : data
//        ]
//        print(PFUser.current()!.objectId!)
//        print(PFUser.current()!.deviceToken)
//
//        print(#line, PFInstallation.current()?.channels ?? "No CHANNELS")
//
//        print("sending push notification...")
//        PFCloud.callFunction(inBackground: "pushToFollowers", withParameters: request as [NSObject : AnyObject], block: { (results:AnyObject?, error:NSError?) in
//            print("push \(String(describing: results!))")
//            if error == nil {
//                print (results!)
//            }
//            else {
//                print (error!)
//            }
//            } as? PFIdResultBlock)
        
        
        
        
        
        
        //PFCloud.callFunction(inBackground: "pushsample", withParameters: ["text" : "\(PFUser.current()!.username!) added a new task: \(String(describing: taskNameTextField.text!))"])
        
//        let push = PFPush()
//        push.setChannel("room2")
//        push.setMessage("TEST")
//        push.sendInBackground()
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        
        //presented modally.
        dismiss(animated: true, completion: nil)
        //presented with push
        navigationController?.popViewController(animated: true)
    }
    
    //programatically change the colour of the shapes
    @objc func handleTap(_ sender:UITapGestureRecognizer) {
        
        guard let priority =  priorityColor.index(of: priorityLevelView.backgroundColor!) else { return }
        let newIndex = priorityColor.startIndex.distance(to: priority) + 1
        priorityLevelView.backgroundColor = priorityColor[newIndex % priorityColor.count]
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

