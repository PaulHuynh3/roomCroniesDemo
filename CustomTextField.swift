//
//  CustomTextField.swift
//  roomCronies
//
//  Created by Jaison Bhatti on 2017-11-02.
//  Copyright © 2017 Paul. All rights reserved.
//

import UIKit

extension UITextField {
    
    // Next step here
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
