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

    @IBOutlet weak var addPresentBtn: UIButton!
    let userKey = "mainUser"
    let uid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPresentBtn.setTitle("Add Present".localized, for: .normal)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if mainUserPhotoURLCache.object(forKey: userKey as NSString) == nil {
            guard uid != nil else { print(Auth.auth().currentUser ?? print("no uid error")); return }
            DataService.instance.getUserInfo(forUid: uid!) { (user) in
                mainUserPhotoURLCache.setObject(user.profileImgURL as NSString, forKey: self.userKey as NSString)
            }
        }
        navigationController?.navigationBar.prefersLargeTitles = true
        getPresents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func getPresents() {
        if let user = Auth.auth().currentUser {
            DataService.instance.getPresents(forUid: user.uid) { ( returnedArray ) in
                if returnedArray.count == 0 {
                    self.presentArray = returnedArray
                    self.collectionView.reloadData()
                } else {
                    self.presentArray = returnedArray
                    self.collectionView.reloadData()
                }
            }
        } else {
            // MARK: PROBLEM CONDITION
            // getTestPresents()
        }
    }
    
    // MARK: Toolbar Button Action
    @IBAction func addBtnPressed(_ sender: Any) {
        let _addPresentsVC = AddPresentsVC()
        _addPresentsVC.modalPresentationStyle = .custom
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
        if presentArray.count == 0 {
            collectionView.setEmptyView(title: "No presents yet".localized, message: "Add presents to share your wishes with friends".localized)
        } else {
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
        _presentInfoVC.modalPresentationStyle = .custom
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
