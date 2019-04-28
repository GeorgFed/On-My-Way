//
//  UserActionButtonCell.swift
//  tableView Test for iPresent
//
//  Created by Georg on 17/04/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import UIKit

class UserActionButtonCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    public func configure(title: String) {
        self.title.text = title
        if title == "Unfollow".localized {
            self.title.textColor = #colorLiteral(red: 0.8470588235, green: 0.3568627451, blue: 0.2941176471, alpha: 1)
        } else {
            self.title.textColor = #colorLiteral(red: 0.5137254902, green: 0.6470588235, blue: 0.7764705882, alpha: 1)
        }
    }
}
