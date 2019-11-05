//
//  EventCollectionCell.swift
//  tableView Test for iPresent
//
//  Created by Georg on 10/10/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import UIKit

class EventCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var name: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupView() {
        let labelText = self.name.text
        let labelSeparated = labelText!.components(separatedBy: " ")
        if labelSeparated.count > 1 {
            self.name.lineBreakMode = .byWordWrapping
            self.name.numberOfLines = 0
        } else {
            self.name.numberOfLines = 1
            self.name.adjustsFontSizeToFitWidth = true
        }
    }
    
    public func configureCell(name: String, day: String,  month: String) {
        print("events info: name \(name), \(day), \(month)")
        self.name.text = name
        self.day.text = day
        self.month.text = month
    }
}

/*
 let labelText = self.mylabel.text //where mylabel is the label
 let labelSeperated = self.labelText.components(seperatedBy: " ")
 if labelSeperated.count > 1 {
     myLabel.lineBreakMode = .byWordWrapping
     myLabel.numberOfLines = 0
 } else {
     myLabel.numberOfLines = 1
     myLabel.adjustsFontSizeToFitWidth = true
 }
 */
