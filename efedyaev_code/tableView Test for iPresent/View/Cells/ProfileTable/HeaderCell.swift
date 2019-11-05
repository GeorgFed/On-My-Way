//
//  HeaderCell.swift
//  tableView Test for iPresent
//
//  Created by Georg on 10/10/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userIndex: UILabel!
    
    @IBOutlet weak var editProfileBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImage.layer.cornerRadius = userImage.frame.height / 2
        let btnImage = UIImage(named: "EditProfile")
        editProfileBtn.setImage(btnImage, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    public func configureCell(userImageURL: String?, username: String, userIndex: String) {
        self.username.text = username
        self.userIndex.text = userIndex
        print(userImageURL)
        if userImageURL != nil {
            self.userImage.loadImgWithURLString(urlString: userImageURL!)
        } else {
            self.userImage.image = UIImage(named: "DefaultBlueFilled")
        }
    }
}
