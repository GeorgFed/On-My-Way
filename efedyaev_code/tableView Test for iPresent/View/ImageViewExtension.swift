//
//  ImageViewExtension.swift
//  tableView Test for iPresent
//
//  Created by Georg on 27/08/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import UIKit

extension UIImageView {
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
    
    public func addShadow() {
        self.layer.shadowOpacity = 0.15
        self.layer.shadowRadius = 6
        self.layer.shadowColor = UIColor.black.cgColor
    }
}
