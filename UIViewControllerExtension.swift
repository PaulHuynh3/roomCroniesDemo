//
//  UIViewControllerExtension.swift
//  roomCronies
//
//  Created by Paul on 2017-10-26.
//  Copyright © 2017 Paul. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showErrorView(_ error: Error?) {
        guard let error = error as NSError?, let errorMessage = error.userInfo["error"] as? String else {
            return
        }
        
        let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""),
                                                message: errorMessage,
                                                preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""),
                                                style: .default))
        present(alertController, animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
}
