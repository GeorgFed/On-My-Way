//
//  PresentEventCollectionCell.swift
//  tableView Test for iPresent
//
//  Created by Georg on 22/03/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import UIKit

class PresentEventCollectionCell: UICollectionViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    func configureCell(name: String, details: String, price: String, imageUrl: String) {
        self.name.text = name
        self.details.text = details
        self.price.text = price
        self.image.loadImgWithURLString(urlString: imageUrl)
    }
}
