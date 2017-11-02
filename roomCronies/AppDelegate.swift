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
        registerForPushNotifications()
        //        createRoom()
        //        createJaison()
        //        createPaul()
        //        paulCreateTask()
        //        paulCreateExpense()
        //        fetchPerson()
//        fetchMembers()
        //testPush()
//        testPush2()
//        testPush3()
//        testPush4()
        testPush5()
    
        return true
    }
    
    
    private func configureParse() {
        
        let configuration = ParseClientConfiguration {
            $0.applicationId = "com.Paul.Room" //changed bundleID to PaulJaison, NOT YET
            $0.clientKey = MASTER_KEY
            $0.server = "http://roomcronies.herokuapp.com/parse"
        }
        Parse.initialize(with: configuration)
        
    }
    
    private func createRoom() {
        
        let room = PFObject(className: "Room")
        
        room["roomName"] = "roomOne"
        
        room.saveInBackground{ (success, error) in
            if let error = error {
                print (#line, error)
                return
            }
            print(#line, success)
            
        }
    }
    
    private func createPaul() {
        
        let paul = PFObject(className: "Person")
        paul["userName"] = "Paul"
        paul["userPassword"] = "password"
        paul["userEmail"] = "paul.huynh3@gmail.com"
        
        
        paul["roomName"] = PFObject.init(withoutDataWithClassName:"Room", objectId: "ogro8r3MMC")
        
        paul.saveInBackground { (success, error) in
            
            if let error = error {
                print(#line, error)
                return
            }
            print(#line, success)
        }
    }
    
    
    
    private func createJaison() {
        
        let jaison = PFObject(className: "Person")
        jaison["userName"] = "Jaison"
        jaison["userPassword"] = "password"
        jaison["userEmail"] = "jb@gmail.com"
        
        
        
        //establish the relationship.
        jaison["roomName"] = PFObject.init(withoutDataWithClassName:"Room", objectId: "ogro8r3MMC")
        
        
        jaison.saveInBackground{ (success, error) in
            if let error = error {
                print (#line, error)
                return
            }
            print(#line, success)
            
        }
    }
    
    private func paulCreateTask() {
        
        let taskOne = PFObject(className: "Task")
        taskOne["taskName"] = "Pay hydro bill"
        taskOne["taskDescription"] = "last month's hydro bill!!!"
        taskOne["isExpense"] = true
        taskOne["priority"] = 1
        taskOne["isComplete"] = false
        taskOne["dateCreated"] = "October 20, 2017"
        
        //establish the relationship.
        //taskCreator
        taskOne["taskCreator"] = PFObject.init(withoutDataWithClassName:"Person", objectId:"gm2hmLvXrA")
        
        
        taskOne.saveInBackground{ (success, error) in
            if let error = error {
                print (#line, error)
                return
            }
            print(#line, success)
            
        }
    }
    
    private func paulCreateExpense() {
        
        let hydroExpense = PFObject(className: "Expense")
        hydroExpense["expenseName"] = "Hydro bill"
        hydroExpense["isPaid"] = false
        hydroExpense["dateCreated"] = "October 20, 2017"
        hydroExpense["dateCompleted"] = "N/A"
        hydroExpense["expenseOwer"] = "Jaison"
        
        
        
        //establish the relationship.
        hydroExpense["expenseCreator"] = PFObject.init(withoutDataWithClassName:"Person", objectId:"0htDcFZSKp")
        hydroExpense["expenseOwer"] = PFObject.init(withoutDataWithClassName:"Person", objectId:"gm2hmLvXrA")
        
        
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
        let query = PFQuery(className: "Person", predicate: predicate)
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
    
    private func fetchMembers() {
        let predicate = NSPredicate(format: "roomName == 'room1'")
        let query = PFQuery(className: "Room", predicate: predicate)
        query.findObjectsInBackground { (rooms: [PFObject]?, error: Error?) in
            if let error = error {
                print(#line, error.localizedDescription)
                return
            }
            guard let rooms = rooms else {
                return
            }
            
            print(rooms)
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
        
        guard let userInstallation = PFUser.current() else { return }
        userInstallation.deviceToken = token
        userInstallation.saveInBackground()
        
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        if (error as NSError).code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handle(userInfo)
    }
    
    
    //MARK: - test push notification
    func testPush5() {
        PFCloud.callFunction(inBackground: "iosPushTest", withParameters: ["text" : "Initialized" ])
    }
    
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void) {
        PFPush.handle(notification.request.content.userInfo)
        completionHandler(.alert)
    }
    
}



//    private func deleteObject() {
//        fetchPersonCompletion{ (person) in
//            person.deleteInBackground(block: { (success, _) in
//                print(#line, "Ian dies!")
//            })
//        }
//    }








