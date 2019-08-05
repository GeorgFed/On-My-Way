//
//  ColorTransition.swift
//  tableView Test for iPresent
//
//  Created by Georg on 05/08/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import UIKit

extension UIView {
    public func activateField(leftColor: UIColor, rightColor: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [
            UIColor.lightGray.cgColor,
            UIColor.lightGray.cgColor
        ]
        gradient.startPoint = CGPoint(x:0, y:1)
        gradient.endPoint = CGPoint(x:1, y:1)
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        // gradientChangeAnimation.beginTime = CACurrentMediaTime() + 2
        gradientChangeAnimation.duration = 0.5
        gradientChangeAnimation.toValue = [
            leftColor.cgColor,
            rightColor.cgColor
        ]
        gradientChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradient.add(gradientChangeAnimation, forKey: nil)
        /*
        let gradient = CAGradientLayer(layer: self.layer)
        gradient.colors = [leftColor.cgColor, rightColor.cgColor]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
        
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 0.2
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        gradient.add(animation, forKey: nil)
         */
    }

    public func deactivateField() {
        self.layer.sublayers?.removeAll()
    }
}
