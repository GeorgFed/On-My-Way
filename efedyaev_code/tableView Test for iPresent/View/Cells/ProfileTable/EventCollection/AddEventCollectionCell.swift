//
//  AddEventCollectionCell.swift
//  tableView Test for iPresent
//
//  Created by Georg on 10/10/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import UIKit

class AddEventCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var addGlyph: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configureCell(title: String, addGlyph: UIImage) {
        self.title.text = title.localized
        self.addGlyph.image = addGlyph
    }
}
