//
//  UserNameCell.swift
//  tableView Test for iPresent
//
//  Created by Georg on 17/04/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import UIKit

class UserNameCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var userStatus: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImage.layer.cornerRadius = userImage.frame.height / 2
        userImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func configure(name: String, uStatus: String, imageUrl: String) {
        self.name.text = name
        self.userStatus.text = uStatus
        self.userImage.loadImgWithURLString(urlString: imageUrl)
    }
}
