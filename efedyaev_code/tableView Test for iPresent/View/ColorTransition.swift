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
    }

    public func deactivateField() {
        self.layer.sublayers?.removeAll()
    }
    
    public func addBlurToView() {
        var blurEffect: UIBlurEffect!
        if #available(iOS 10.0, *) {
            blurEffect = UIBlurEffect(style: .dark)
        } else {
            blurEffect = UIBlurEffect(style: .light)
        }
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = self.bounds
        blurredEffectView.alpha = 0.9
        blurredEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurredEffectView)
    }
    
    public func removeBlurFromView() {
        for subview in self.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
    }
    
}
