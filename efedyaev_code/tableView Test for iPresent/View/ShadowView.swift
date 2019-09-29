//
//  ShadowView.swift
//  iPresent prot. auth
//
//  Created by Georg on 13.05.18.
//  Copyright © 2018 Georg. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    override func awakeFromNib() {
        self.layer.shadowOpacity = 0.15
        self.layer.shadowRadius = 6
        self.layer.shadowColor = UIColor.black.cgColor
    }
    
}