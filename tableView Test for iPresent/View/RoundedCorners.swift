//
//  RoundedCorners.swift
//  iPresent prot. auth
//
//  Created by Georg on 24.05.18.
//  Copyright © 2018 Georg. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedCorners: UIView {

    @IBInspectable var cornerRadius: CGFloat = 3.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    override func awakeFromNib() {
        self.setUpView()
    }
    func setUpView() {
        self.layer.cornerRadius = cornerRadius
        
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setUpView()
    }
}
