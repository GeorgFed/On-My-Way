//
//  FRecommendationsVC.swift
//  tableView Test for iPresent
//
//  Created by Georg on 11/07/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import UIKit
import Firebase

class FRecommendationsVC: UIViewController {
    let uid = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var tableView: UITableView!
    
    var rUsers: [User] = []
    var chosenUser: User?
    
    override func viewWillAppear(_ animated: Bool) {
        if let selectionIndexPath = tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = #colorLiteral(red: 0.4509803922, green: 0.6549019608, blue: 0.8588235294, alpha: 1)
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
            navigationItem.standardAppearance = appearance
            navigationItem.scrollEdgeAppearance = appearance
        }
        
        self.navigationItem.title = "Recommendations".localized
        getRecommendations()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // .default
    }
    
    func getRecommendations() {
        ContactsService.instance.getPhoneNumbers(on: self) { (phones, success) in
            if success {
                print("success", phones)
                self.findUsers(phones: phones)
            } else {
                print("Contacts Error")
            }
        }
    }
    
    func findUsers(phones: [String]) {
        print(phones)
        for p in phones {
            FriendSystem.instance.findUsers(uid!, byPhoneNumber: p) { ( returnedUsers) in
                print(returnedUsers)
                self.rUsers.append(contentsOf: returnedUsers)
                self.rUsers = Array(self.rUsers.mapToSet({ $0 }))
                if returnedUsers.count > 0 {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                print(self.rUsers)
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
}

extension FRecommendationsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(rUsers.count)
        return rUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "basicCell")
        let url = rUsers[indexPath.row].profileImgURL
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "basicCell")
        }
        cell?.textLabel?.text = rUsers[indexPath.row].name
        /*
        DispatchQueue.main.async {
            cell!.imageView!.loadImgWithURLString(urlString: url)
        }
 
        let cellImageLayer: CALayer?  = cell?.imageView!.layer
        cellImageLayer!.cornerRadius = 35
        cellImageLayer!.masksToBounds = true
        */
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenUser = rUsers[indexPath.row]
        self.performSegue(withIdentifier: "showUser", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUser" {
            guard chosenUser == chosenUser else { return }
            let _UserVC = segue.destination as! UserVC
            _UserVC.user = chosenUser
        }
    }
}
