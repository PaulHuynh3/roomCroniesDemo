//
//  DataManager.swift
//  roomCronies
//
//  Created by Paul on 2017-10-27.
//  Copyright © 2017 Paul. All rights reserved.
//

import Foundation
import Parse

class DataManager {
    static func getRoom(completion:@escaping (Room)->()) {
        guard let currentUser = PFUser.current() else { return }
        let roomQuery = Room.query()
        
        roomQuery?.whereKey("members", equalTo: currentUser)
        
        roomQuery?.findObjectsInBackground(block: { (objects, error) in
            if let error = error {
                print(#line, error.localizedDescription)
                return
            }
            guard let objects = objects else { return }
            guard let room = objects.first as? Room else {
                print(#line, "problems")
                fatalError()
            }
            print(#line, room.roomName)
            completion(room)
        })
    }
}
