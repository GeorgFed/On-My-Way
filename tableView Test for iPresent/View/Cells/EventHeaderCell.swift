//
//  EventHeaderCell.swift
//  tableView Test for iPresent
//
//  Created by Georg on 21/03/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import UIKit

class EventHeaderCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var eventImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        eventImg.layer.cornerRadius = eventImg.frame.height / 2
        eventImg.clipsToBounds = true
//        profileImg.layer.cornerRadius = profileImg.frame.height / 2
//        profileImg.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func configureCell(date: String, fname: String, imgURL: String) {
        self.date.text = date
        self.friendName.text = fname
        self.eventImg.loadImgWithURLString(urlString: imgURL)
    }
}
