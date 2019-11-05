//
//  SettingsCell.swift
//  tableView Test for iPresent
//
//  Created by Georg on 10/10/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    @IBOutlet weak var settingName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    public func configureCell(settingName: String) {
        self.settingName.text = settingName
    }
}
