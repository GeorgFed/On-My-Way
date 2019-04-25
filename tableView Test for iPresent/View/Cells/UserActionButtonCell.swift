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
    }
}
