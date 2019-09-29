//
//  FloatingButton.swift
//  tableView Test for iPresent
//
//  Created by Georg on 27/08/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import UIKit

public class FloatingButton {
    static let instance = FloatingButton()
    
    private static let buttonHeight: CGFloat = 75.0
    private static let buttonWidth: CGFloat = 75.0
    private let roundValue = FloatingButton.buttonHeight/2
    private let trailingValue: CGFloat = 15.0
    // private let leadingValue: CGFloat = 15.0
    private let shadowRadius: CGFloat = 8.0
    private let shadowOpacity: Float = 0.15
    private let shadowOffset = CGSize(width: 0.0, height: 2.0)
    private let scaleKeyPath = "scale"
    private let animationKeyPath = "transform.scale"
    private let animationDuration: CFTimeInterval = 0.4
    private let animateFromValue: CGFloat = 1.00
    private let animateToValue: CGFloat = 1.05
    
    public func createFloatingButton(floatingButton: UIButton!, floatingButtonImageName: String!, leadingValue: CGFloat!) {
        floatingButton?.translatesAutoresizingMaskIntoConstraints = false
        floatingButton?.backgroundColor = .white
        floatingButton?.setImage(UIImage(named: floatingButtonImageName), for: .normal)
        constrainFloatingButtonToWindow(floatingButton: floatingButton, leadingValue: leadingValue)
        makeFloatingButtonRound(floatingButton: floatingButton)
        addShadowToFloatingButton(floatingButton: floatingButton)
        addScaleAnimationToFloatingButton(floatingButton: floatingButton)
    }
    
    private func constrainFloatingButtonToWindow(floatingButton: UIButton!, leadingValue: CGFloat!) {
        DispatchQueue.main.async {
            guard let keyWindow = UIApplication.shared.keyWindow else { return }
            keyWindow.addSubview(floatingButton)
            keyWindow.trailingAnchor.constraint(equalTo: floatingButton.trailingAnchor,
                                                constant: self.trailingValue).isActive = true
            keyWindow.bottomAnchor.constraint(equalTo: floatingButton.bottomAnchor,
                                              constant: leadingValue).isActive = true
            floatingButton.widthAnchor.constraint(equalToConstant:
                FloatingButton.buttonWidth).isActive = true
            floatingButton.heightAnchor.constraint(equalToConstant:
                FloatingButton.buttonHeight).isActive = true
        }
    }
    
    private func makeFloatingButtonRound(floatingButton: UIButton!) {
        floatingButton.layer.cornerRadius = roundValue
    }
    
    private func addShadowToFloatingButton(floatingButton: UIButton!) {
        floatingButton?.layer.shadowColor = UIColor.black.cgColor
        floatingButton?.layer.shadowOffset = shadowOffset
        floatingButton?.layer.masksToBounds = false
        floatingButton?.layer.shadowRadius = shadowRadius
        floatingButton?.layer.shadowOpacity = shadowOpacity
    }

    private func addScaleAnimationToFloatingButton(floatingButton: UIButton!) {
        // Add a pulsing animation to draw attention to button:
        DispatchQueue.main.async {
            let scaleAnimation: CABasicAnimation = CABasicAnimation(keyPath: self.animationKeyPath)
            scaleAnimation.duration = self.animationDuration
            scaleAnimation.repeatCount = .greatestFiniteMagnitude
            scaleAnimation.autoreverses = true
            scaleAnimation.fromValue = self.animateFromValue
            scaleAnimation.toValue = self.animateToValue
            floatingButton.layer.add(scaleAnimation, forKey: self.scaleKeyPath)
        }
    }
}




