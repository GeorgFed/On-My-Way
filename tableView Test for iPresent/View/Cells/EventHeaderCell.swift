//
//  EventHeaderCell.swift
//  tableView Test for iPresent
//
//  Created by Georg on 21/03/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import UIKit

class EventHeaderCell: UITableViewCell {

    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var eventImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        eventImg.layer.cornerRadius = eventImg.frame.height / 2
        eventImg.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func configureCell(day: String, month: String, fname: String, imgURL: String) {
        self.day.text = day
        self.month.text = month
        self.friendName.text = fname
        self.eventImg.loadImgWithURLString(urlString: imgURL)
    }
}
