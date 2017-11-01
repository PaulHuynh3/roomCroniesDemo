//
//  Gradient.swift
//  roomCronies
//
//  Created by Jaison Bhatti on 2017-11-01.
//  Copyright © 2017 Paul. All rights reserved.
//

import UIKit

extension UIView {
    func addGradientWithColor(topColor: UIColor, bottomColor: UIColor) {
        //_ = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [topColor.cgColor, bottomColor.cgColor]
        
        self.layer.insertSublayer(gradient, at: 0)
    }
}

