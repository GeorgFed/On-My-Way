//
//  PresentCell.swift
//  tableView Test for iPresent
//
//  Created by Georg on 21.10.2018.
//  Copyright © 2018 Georg. All rights reserved.
//

import UIKit

class PresentCell: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var backgroundImg: UIImageView!
    
    override func awakeFromNib() {
    }
    
    public func configureCell(name: String, price: String, details: String, imageName: Data) {
        self.name.text = name
        self.price.text = price
        self.details.text = details
        self.backgroundImg.image = UIImage(data: imageName)
        // self.backgroundImg.image = UIImage(named: imageName)
    }
}
