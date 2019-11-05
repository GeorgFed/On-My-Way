//
//  ProfileTableVC.swift
//  tableView Test for iPresent
//
//  Created by Georg on 10/10/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import UIKit
import Firebase

class ProfileTableVC: UITableViewController {
    
    let user = Auth.auth().currentUser
    let userid = Auth.auth().currentUser?.uid
    let userKey = "mainUser"
    let reuseIDs = ["title", "header", "collection", "settings"]
    let settingNames = ["Language", "Currency"]
    let settingGlyphNames = ["SignOut", "DeleteAccount"]
    
    var profileImgURL:String?
    var userName: String?
    var userIndex: String?
    var birthdate: String?
    
    var events = [Event]()
    
    override func viewWillAppear(_ animated: Bool) {
        // Add a background view to the table view
        self.setNeedsStatusBarAppearanceUpdate()
        
        let backgroundImage = UIImage(named: "TableBGNew")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleToFill
        self.tableView.backgroundView = imageView
         
        getEvents()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        
        
        let backgroundImage = UIImage(named: "TableBGNew")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleToFill
        self.tableView.backgroundView = imageView
                
        NotificationCenter.default.addObserver(self, selector: #selector(updateDetails), name: NSNotification.Name(rawValue: "UpdateProfileDetails"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updatePhoto), name: NSNotification.Name(rawValue: "UpdatePhoto"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getEvents), name: NSNotification.Name(rawValue: Notifications.eventAdded), object: nil)
        
        handleConnection()
        if !Reachability.isConnectedToNetwork() {
            tableView.setEmptyView(title: "No internet connection".localized, message: "", alertImage: .noInternet)
            return
        } else {
            tableView.restore()
        }
        
        guard userid != nil else {
            print("No UserID Error")
            tableView.setEmptyView(title: "Unknown error".localized, message: "", alertImage: .unknown)
            return
        }
        
        DataService.instance.getUserInfo(forUid: userid!) { (user) in
            self.profileImgURL = user.profileImgURL
            self.tableView.reloadData()
        }
        
        if mainUserPhotoURLCache.object(forKey: userKey as NSString) == nil {
            DataService.instance.getUserInfo(forUid: userid!) { (user) in
                mainUserPhotoURLCache.setObject(user.profileImgURL as NSString, forKey: "mainUser" as NSString)
            }
        }
        
        if mainUserPhotoURLCache.object(forKey: userKey as NSString) == nil {
            updatePhoto()
        } else {
            self.profileImgURL = mainUserPhotoURLCache.object(forKey: userKey as NSString) as String?
        }
        
        if let username = mainUserNameCache.object(forKey: userKey as NSString) {
            self.userName = username as String
        }
        if let photourl = mainUserPhotoURLCache.object(forKey: userKey as NSString) {
            self.profileImgURL = photourl as String
        }
        
        updateDetails()
        
        
        // MARK: - Catch notification: photo updated/info updated
        print(self.userName ?? "No Username")
        print(self.profileImgURL ?? "No Profile Image")
    }

    @objc func updateDetails() {
        DataService.instance.getUserInfo(forUid: userid!) { (user) in
            self.birthdate = user.birthdate
            self.userName = user.name
            self.tableView.reloadData()
        }
    }
    
    @objc func updatePhoto() {
        DataService.instance.getUserInfo(forUid: userid!) { (user) in
            self.profileImgURL = user.profileImgURL
            self.tableView.reloadData()
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func getEvents() {
        DataService.instance.getEvents(forUid: user!.uid) { ( returnedEvents ) in
            self.events = returnedEvents.sorted(by: { (one, two) -> Bool in
                one.convertedDate < two.convertedDate
            })
            print(self.events.count);
            self.tableView.reloadData()
        }
    }
    
    func handleConnection() {
        NotificationCenter.default.addObserver(self, selector: #selector(networkRestored), name: Notification.Name(ConnectionKeys.cellular), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(networkRestored), name: Notification.Name(ConnectionKeys.wifi), object: nil)
    }
    
    @objc func networkRestored() {
        print("Network restored")
        getEvents()
        DataService.instance.getUserInfo(forUid: userid!) { (user) in
            self.userName = user.name
            self.profileImgURL = user.profileImgURL
        }
        tableView.reloadData()
        tableView.restore()
    }
    
    @objc func editPressed(sender: UIButton) {
        print("here")
        print(sender)
        performSegue(withIdentifier: "editProfileSegue", sender: sender)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editProfileSegue" {
            let vc = segue.destination as! EditProfileTable
            if let fullName = userName?.components(separatedBy: " "),
                let userid = userid {
                vc.currentURL = profileImgURL
                vc.firstName = fullName[0]
                print(fullName.count)
                if fullName.count > 1 { vc.lastName = fullName[1] }
                vc.userid = userid
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseID = indexPath.row > 3 ? reuseIDs[3] : reuseIDs[indexPath.row]
        
        // MARK: - Must Add Missing Info
        switch indexPath.row {
        case 0:
            let cell: TitleCell! = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as? TitleCell
            cell.backgroundColor = .clear
            cell.backgroundView = UIView()
            cell.selectedBackgroundView = UIView()
            cell.configureCell(title: "Profile")
            return cell!
        case 1:
            let cell: HeaderCell! = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as? HeaderCell
            cell.backgroundColor = .clear
            cell.backgroundView = UIView()
            cell.selectedBackgroundView = UIView()
            // cell.configureCell(userImage: UIImage(named: "") ?? UIImage(named: "DefaultBlueFilled")!, username: userName ?? "", userIndex: userIndex ?? "")
            cell.configureCell(userImageURL: profileImgURL, username: userName ??
                "", userIndex: userIndex ?? "")
            cell.editProfileBtn.addTarget(self, action: #selector(editPressed(sender:)), for: .touchUpInside)
            return cell!
        case 2:
            let cell: UserEventCollectionCell! = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as? UserEventCollectionCell
            cell.backgroundColor = .clear
            cell.backgroundView = UIView()
            cell.selectedBackgroundView = UIView()
            cell.configureCell(events: events)
            return cell!
        default:
            let cell: SettingsCell! = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as? SettingsCell
            cell.backgroundColor = .clear
            cell.backgroundView = UIView()
            cell.selectedBackgroundView = UIView()
            cell.configureCell(settingName: settingNames[indexPath.row - 3])
            return cell!
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
        if indexPath.row == 3 {
            // showSignOutAlert()
        } else if indexPath.row == 4 {
            // showDeleteAlert()
        }
         */
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = .clear
        
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row < 3 {
            return nil
        }
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 64
        case 1:
            return 160
        case 2:
            return 177
        default:
            return 64
        }
    }
}
