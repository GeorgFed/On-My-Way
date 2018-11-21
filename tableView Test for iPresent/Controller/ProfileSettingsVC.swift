//
//  ProfileSettingsVC.swift
//  tableView Test for iPresent
//
//  Created by Georg on 01.11.2018.
//  Copyright © 2018 Georg. All rights reserved.
//

import UIKit

class ProfileSettingsVC: UIViewController {

    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var fullNameTxt: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    let profile_settings = ["Personal Information", "Friend Request", "About", "Sign Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        setUpView()
    }
    
    func setUpView() {
        fullNameTxt.text = "George Fed"
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ProfileSettingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "_settings")
        if cell == nil {
            if indexPath.row == 3 {
                cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "_signout")
                cell?.textLabel?.textColor = #colorLiteral(red: 0.8078431373, green: 0.3294117647, blue: 0.2392156863, alpha: 1)
            } else {
                cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "_settings")
                cell?.accessoryType = .disclosureIndicator
            }
        }
        
        cell!.textLabel?.text = self.profile_settings[indexPath.row]
        return cell!
    }
}

