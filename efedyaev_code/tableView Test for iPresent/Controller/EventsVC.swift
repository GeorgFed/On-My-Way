//
//  EventsVC.swift
//  tableView Test for iPresent
//
//  Created by Georg on 17/03/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import UIKit
import Firebase

class EventsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let uid = Auth.auth().currentUser?.uid
    
    var friendsIDs = [String]()
    var events = [Event]()
    var friendForEvent = [Event : User]()
    var chosen_user: User?
    var loaded: Bool?
    
    let refreshControl = UIRefreshControl()
    
    override func viewWillAppear(_ animated: Bool) {
        FriendSystem.instance.addFollowsObserver(uid) { }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        handleConnection()
        
        if !Reachability.isConnectedToNetwork() {
            refreshControl.endRefreshing()
            tableView.setEmptyView(title: "No internet connection".localized, message: "", alertImage: .noInternet)
        }
        
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(update),
                                               name: Notification.Name("updateUsers"),
                                               object: nil)
        // setLoadingScreen()
        LoadingService.instance.setLoadingScreen(tableView: tableView, navHeight: (navigationController?.navigationBar.frame.height)!)
        loaded = false
        update()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // .default
    }
    
    @objc func update() {
        guard let uid = uid else { return }
        FriendSystem.instance.addFollowsObserver(uid) {
            self.fetchData()
        }
    }
    
    @objc func fetchData() {
        for friend in FriendSystem.instance.followsList {
            DataService.instance.getEvents(forUid: friend.uid) { ( returnedEvents ) in
                self.events.append(contentsOf: returnedEvents)
                self.events = Array(self.events.mapToSet({ $0 }))
                self.events.sort(by: { (one, two) -> Bool in
                    one.convertedDate < two.convertedDate
                })
                self.events = self.events.filter({ (event) -> Bool in
                    event.convertedDate > Date()
                })
                for event in returnedEvents {
                    self.friendForEvent[event] = friend
                }
                self.tableView.reloadData()
            }
        }
        // removeLoadingScreen()
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.main.async {
            LoadingService.instance.removeLoadingScreen()
            group.leave()
        }
        
        refreshControl.endRefreshing()
        
        group.notify(queue: .main) {
            if self.events.count == 0 {
                self.tableView.setEmptyView(title: "No events yet".localized, message: "Here you will see the upcoming events of your friends".localized, alertImage: .noEvents)
            } else {
                self.tableView.restore()
            }
        }
        
        self.tableView.reloadData()
    }
    
    func handleConnection() {
        NotificationCenter.default.addObserver(self, selector: #selector(networkRestored), name: Notification.Name(ConnectionKeys.cellular), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(networkRestored), name: Notification.Name(ConnectionKeys.wifi), object: nil)
    }
    
    @objc func networkRestored() {
        print("Network restored")
        update()
        tableView.restore()
    }
}

extension EventsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: EventHeaderCell! = tableView.dequeueReusableCell(withIdentifier: "EventHeaderCell") as? EventHeaderCell
            cell.configureCell(day: events[indexPath.section].day, month: events[indexPath.section].month, fname: friendForEvent[events[indexPath.section]]!.name, imgURL: friendForEvent[events[indexPath.section]]!.profileImgURL)
            //cell.configureCell(date: events[indexPath.section].date, fname: friendForEvent[events[indexPath.section]]!.name, imgURL: friendForEvent[events[indexPath.section]]!.profileImgURL)
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell: EventTitleCell! = tableView.dequeueReusableCell(withIdentifier: "EventTitleCell") as? EventTitleCell
            cell.configureCell(title: events[indexPath.section].title)
            return cell
        default:
            let cell: PresentCollectionCell! = tableView.dequeueReusableCell(withIdentifier: "PresentCollectionCell") as? PresentCollectionCell
            cell.configureCollectionCell(f: friendForEvent[events[indexPath.section]]!)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 64.0
        case 1:
            return 44.0
        default:
            return 340.0
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row > 0 {
            return nil
        }
        return indexPath
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerHeight: CGFloat
        headerHeight = CGFloat.leastNonzeroMagnitude
        return headerHeight
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let footerHeight: CGFloat
        footerHeight = 8.0
        return footerHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            self.chosen_user = friendForEvent[events[indexPath.section]]!
            self.performSegue(withIdentifier: "segueForUser", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard chosen_user != nil else { return }
        let _UserVC = segue.destination as! UserVC
        _UserVC.user = chosen_user
    }
}


// TODO: clear unused functions, create a method call sequence w/ DispathThreads & Symophores
// TODO: Handle network errors
// TODO: check login with a new account
// TODO: check events

// TODO: GLOBAL _ STANDART EVENTS?

