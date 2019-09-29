//
//  EventCell.swift
//  tableView Test for iPresent
//
//  Created by Georg on 21/03/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var month: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configureCell(name: String, details: String, day: String, month: String) {
        self.name.text = name
        self.details.text = details
        self.day.text = day
        self.month.text = month
    }

}
