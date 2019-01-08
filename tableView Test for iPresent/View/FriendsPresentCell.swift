//
//  FriendsPresentCell.swift
//  tableView Test for iPresent
//
//  Created by Georg on 18.11.2018.
//  Copyright © 2018 Georg. All rights reserved.
//

import UIKit

class FriendsPresentCell: UICollectionViewCell {
    
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        
    }
    
    public func configureCell(name: String, price: String, details: String, imageName: String) {
        self.name.text = name
        self.details.text = details
        self.price.text = price
        self.backgroundImg.loadImgWithURLString(urlString: imageName)
    }
}
