//
//  R.swift
//  roomCronies
//
//  Created by Paul on 2017-10-26.
//  Copyright © 2017 Paul. All rights reserved.
//

import Foundation

// MARK: - Resources

class R {
    static let wallPicturesTableViewController = "WallPicturesTableViewController"
    
    static func error(with message: String) -> Error {
        let error = NSError(domain: "Custom", code: 100, userInfo: ["error" : message]) as Error
        return error
    }
    
    static let wallPost = "WallPost"
}
