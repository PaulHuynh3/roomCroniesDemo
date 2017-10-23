//
//  AppDelegate.swift
//  roomCronies
//
//  Created by Paul on 2017-10-19.
//  Copyright © 2017 Paul. All rights reserved.
//

import UIKit
import Parse
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        configureParse()
        createRoom()
//        createJaison()
//        createPaul()
//        paulCreateTask()
//        paulCreateExpense()
//        fetchPerson()
        registerForPushNotifications()
        
        return true
    }
    
    
    private func configureParse() {
        
        let configuration = ParseClientConfiguration {
            $0.applicationId = "com.Paul.Room"
            $0.clientKey = MASTER_KEY
            $0.server = "http://roomcronies.herokuapp.com/parse"
        }
        Parse.initialize(with: configuration)
        
    }
    
    private func createRoom() {
        
        let room = PFObject(className: "room")
        
        room["roomName"] = "Party Room"
        
        room["personInRoom"] = PFObject.init(withoutDataWithClassName:"person", objectId:"gm2hmLvXrA")
        
        room.saveInBackground{ (success, error) in
            if let error = error {
                print (#line, error)
                return
            }
            print(#line, success)
            
        }
    }
    
    private func createPaul() {
        
        let paul = PFObject(className: "person")
        paul["userName"] = "Paul"
        paul["userPassword"] = "password"
        paul["userEmail"] = "paul.huynh3@gmail.com"
    
        
        paul["roomName"] = PFObject.init(withoutDataWithClassName:"room", objectId: "AZqNFRt8BA")
        
        paul.saveInBackground { (success, error) in
            
            if let error = error {
                print(#line, error)
                return
            }
            print(#line, success)
        }
    }
    
    
    
    private func createJaison() {
        
        let jaison = PFObject(className: "person")
        jaison["userName"] = "Jaison"
        jaison["userPassword"] = "password"
        jaison["userEmail"] = "jb@gmail.com"
        
        
        
        //establish the relationship.
        //Room
        jaison["roomName"] = PFObject.init(withoutDataWithClassName:"room", objectId: "AZqNFRt8BA")
        

        jaison.saveInBackground{ (success, error) in
            if let error = error {
                print (#line, error)
                return
            }
            print(#line, success)
            
        }
    }
    
    private func paulCreateTask() {
        
        let taskOne = PFObject(className: "task")
        taskOne["taskName"] = "Pay hydro bill"
        taskOne["taskDescription"] = "last month's hydro bill!!!"
        taskOne["isExpense"] = true
        taskOne["priority"] = 1
        taskOne["isComplete"] = false
        taskOne["dateCreated"] = "October 20, 2017"
        
        //establish the relationship.
        //taskCreator
        taskOne["taskCreator"] = PFObject.init(withoutDataWithClassName:"person", objectId:"gm2hmLvXrA")
        
        
        taskOne.saveInBackground{ (success, error) in
            if let error = error {
                print (#line, error)
                return
            }
            print(#line, success)
            
        }
    }
    
    private func paulCreateExpense() {
    
        let hydroExpense = PFObject(className: "expense")
        hydroExpense["expenseName"] = "Hydro bill"
        hydroExpense["isPaid"] = false
        hydroExpense["dateCreated"] = "October 20, 2017"
        hydroExpense["dateCompleted"] = "N/A"
        hydroExpense["expenseOwer"] = "Jaison"
        
      
        
        //establish the relationship.
        hydroExpense["expenseCreator"] = PFObject.init(withoutDataWithClassName:"person", objectId:"0htDcFZSKp")
        hydroExpense["expenseOwer"] = PFObject.init(withoutDataWithClassName:"person", objectId:"gm2hmLvXrA")
        
        
        hydroExpense.saveInBackground{ (success, error) in
            if let error = error {
                print (#line, error)
                return
            }
            print(#line, success)
            
        }
        
    }
    
    
    
    //this fetches the person based on predicate
    private func fetchPerson() {
        let predicate = NSPredicate(format: "age > 18")
        let query = PFQuery(className: "person", predicate: predicate)
        query.findObjectsInBackground {(person: [PFObject]?, error: Error?) in
            
            if let error = error {
                print(#line, error.localizedDescription)
                return
            }
            guard let person = person else {
                
                return
            }
            
            
            for jaison in person {
                
                print(jaison)
            }
            
        }
        
    }

    //MARK: - adding push notifications
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            OperationQueue.main.addOperation {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        
        let installation = PFInstallation.current()
        installation?.setDeviceTokenFrom(deviceToken)
        installation?.saveInBackground()
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handle(userInfo)
}

}






    //    private func deleteObject() {
    //        fetchPersonCompletion{ (person) in
    //            person.deleteInBackground(block: { (success, _) in
    //                print(#line, "Ian dies!")
    //            })
    //        }
    //    }








