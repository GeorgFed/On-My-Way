//
//  ProfileVC.swift
//  tableView Test for iPresent
//
//  Created by Georg on 21.10.2018.
//  Copyright © 2018 Georg. All rights reserved.
//

import UIKit
import Firebase
import Contacts
import ContactsUI
import PhoneNumberKit

class PresentsVC: UIViewController, UIScrollViewDelegate {
    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    var presentArray = [Present]()
    // @IBOutlet weak var addPresentBtn: UIButton!
    let userKey = "mainUser"
    let uid = Auth.auth().currentUser?.uid
    let refreshControl = UIRefreshControl()
    let fabImageName = "fab"
    var floatingButton: UIButton?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        floatingButton = UIButton(type: .custom)
        let leadingValue = (tabBarController?.tabBar.frame.size.height)!
        FloatingButton.instance.createFloatingButton(floatingButton: floatingButton, floatingButtonImageName: fabImageName, leadingValue: leadingValue + 16.0)
        floatingButton?.addTarget(self, action: #selector(addFabPressed), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        addPresentBtn.setTitle("Add Present".localized, for: .normal)
//        addPresentBtn.isHidden = true
//        addPresentBtn.isEnabled = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        handleConnection()
        
        if !Reachability.isConnectedToNetwork() {
            collectionView.setEmptyView(title: "No internet connection".localized, message: "", alertImage: .noInternet)
            return
        } else {
            collectionView.restore()
        }
        
        
        if mainUserPhotoURLCache.object(forKey: userKey as NSString) == nil {
            guard uid != nil else { print(Auth.auth().currentUser ?? print("no uid error")); return }
            DataService.instance.getUserInfo(forUid: uid!) { (user) in
                mainUserPhotoURLCache.setObject(user.profileImgURL as NSString, forKey: self.userKey as NSString)
            }
        }
        navigationController?.navigationBar.prefersLargeTitles = false
        LoadingService.instance.setLoadingScreen(collectionView: collectionView, navHeight: (navigationController?.navigationBar.frame.height)!)
        getPresents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        hideButton()
        super.viewWillDisappear(animated)
    }
    
    func hideButton() {
        guard floatingButton?.superview != nil else {  return }
        DispatchQueue.main.async {
            self.floatingButton?.removeFromSuperview()
            self.floatingButton = nil
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func handleConnection() {
        NotificationCenter.default.addObserver(self, selector: #selector(networkRestored), name: Notification.Name(ConnectionKeys.cellular), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(networkRestored), name: Notification.Name(ConnectionKeys.wifi), object: nil)
    }
    
    @objc func networkRestored() {
        print("Network restored")
        LoadingService.instance.setLoadingScreen(collectionView: collectionView, navHeight: (navigationController?.navigationBar.frame.height)!)
        getPresents()
        collectionView.restore()
    }
    
    @objc func getPresents() {
        if let user = Auth.auth().currentUser {
            DataService.instance.getPresents(forUid: user.uid) { ( returnedArray ) in
                LoadingService.instance.removeLoadingScreen()
                if returnedArray.count == 0 {
                    self.collectionView.setEmptyView(title: "No presents yet".localized, message: "Add presents to share your wishes with friends".localized, alertImage: .noPresents)
                } else {
                    self.presentArray = returnedArray
                    self.collectionView.reloadData()
                }
            }
        } else {
            // MARK: PROBLEM CONDITION
            collectionView.setEmptyView(title: "An unknown error has occured".localized, message: "", alertImage: .unknown)
        }
        // removeLoadingScreen()
        /*
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.main.async {
            LoadingService.instance.removeLoadingScreen()
            print("Loading stopped")
            group.leave()
        }
        */
        
        /*
        group.notify(queue: .main) {
            if self.presentArray.count == 0 {
                if Reachability.isConnectedToNetwork() {
                    print(self.presentArray.count)
                    self.collectionView.setEmptyView(title: "No presents yet".localized, message: "Add presents to share your wishes with friends".localized, alertImage: .noPresents)
                }
            } else {
                self.collectionView.restore()
            }
        }
        */
    }
    
    @objc func addFabPressed() {
        let _addPresentsVC = AddPresentsVC()
        _addPresentsVC.modalPresentationStyle = .fullScreen
        present(_addPresentsVC, animated: true, completion: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(getPresents),
                                               name: NSNotification.Name(Notifications.presentAdded),
                                               object: nil)
    }
    
    // MARK: Toolbar Button Action
    @IBAction func addBtnPressed(_ sender: Any) {
        let _addPresentsVC = AddPresentsVC()
        _addPresentsVC.modalPresentationStyle = .fullScreen
        present(_addPresentsVC, animated: true, completion: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(getPresents),
                                               name: NSNotification.Name(Notifications.presentAdded),
                                               object: nil)
    }
}

// MARK: Collection View Delegate
extension PresentsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PresentCell", for: indexPath) as? PresentCell {
            let name = presentArray[indexPath.row].name
            let details = presentArray[indexPath.row].details
            let price = presentArray[indexPath.row].price
            let img = presentArray[indexPath.row].imageName
            cell.configureCell(name: name, price: price, details: details, imageName: img)
            
            cell.contentView.layer.cornerRadius = 3.0
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = true;
            
            cell.layer.shadowColor = UIColor.lightGray.cgColor
            cell.layer.shadowOffset = CGSize(width:0,height: 2.0)
            cell.layer.shadowRadius = 6.0
            cell.layer.shadowOpacity = 0.15
            cell.layer.masksToBounds = false;
            cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds,
                                                 cornerRadius:cell.contentView.layer.cornerRadius).cgPath
            return cell
        }
        return PresentCell()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if presentArray.count > 0 && Reachability.isConnectedToNetwork() {
            collectionView.restore()
        }
        return presentArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // return CGSize(width: screenWidth / 2 - 2, height: screenWidth / 2 - 2)
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + flowLayout.minimumInteritemSpacing
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(2))
        return CGSize(width: size, height: Int(Double(size) * 1.5))
    }
 
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: ADDITTIONAL PRESENT INFO APPEARENCE
        let current_present = presentArray[indexPath.row]
        let _presentInfoVC = PresentInfoVC(nibName: "PresentInfoVC", bundle: nil)
        _presentInfoVC.selected_item = current_present
        _presentInfoVC.modalPresentationStyle = .fullScreen
        present(_presentInfoVC, animated: true, completion: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(getPresents),
                                               name: NSNotification.Name(Notifications.presentDeleted),
                                               object: nil)
    }
    
    // Screen width.
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    // Screen height.
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
}
