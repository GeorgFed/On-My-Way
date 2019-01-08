//
//  UserInfoVC.swift
//  tableView Test for iPresent
//
//  Created by Georg on 15.11.2018.
//  Copyright © 2018 Georg. All rights reserved.
//

import UIKit

class UserInfoVC: UIViewController {

    var user: User?
    var presentArray = [Present]()
    
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        getPresents()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        setUpView()
    }
    
    // MARK: Requires DB UPD
    func getPresents() {
//        TestDataService.instance.getPresent(forUid: "666") { (returnedArray) in
//            self.presentArray = returnedArray
//        }
        DataService.instance.getPresents(forUid: user?.uid ?? "") { ( returnedArray ) in
            self.presentArray = returnedArray
            self.collectionView.reloadData()
        }
    }

    func setUpView() {
        fullName.text = user?.name
        profileImg.layer.cornerRadius = profileImg.frame.height / 2
        profileImg.clipsToBounds = true
        
        if let url = user?.profileImgURL {
            /*
            DataService.instance.getUserImgForURL(forURL: url) { ( data ) in
                if data != nil {
                    self.profileImg.image = UIImage(data: data!)
                }
            }
             */
            profileImg.loadImgWithURLString(urlString: url)
        }
        
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension UserInfoVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presentArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsPresentCell", for: indexPath) as? FriendsPresentCell {
            let name = presentArray[indexPath.row].name
            let details = presentArray[indexPath.row].details
            let price = presentArray[indexPath.row].price
            let img = presentArray[indexPath.row].imageName
            /*
            if (img != "BackImg2" && img != "DefaultProfileImage") {
                DataService.instance.getUserImgForURL(forURL: img) { (data) in
                    if data != nil {
                        cell.configureCell(name: name, price: price, details: details, imageName: data!)
                    } else {
                        print("error")
                        return
                    }
                }
            } else {
                let data = UIImage(named: img)?.jpegData(compressionQuality: 0.5)
                cell.configureCell(name: name, price: price, details: details, imageName: data!)
            }
            */
            cell.configureCell(name: name, price: price, details: details, imageName: img)
            cell.contentView.layer.cornerRadius = 3.0
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = true;
            
            cell.layer.shadowColor = UIColor.lightGray.cgColor
            cell.layer.shadowOffset = CGSize(width:0,height: 2.0)
            cell.layer.shadowRadius = 2.0
            cell.layer.shadowOpacity = 1.0
            cell.layer.masksToBounds = false;
            cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
            
            return cell
        }
        return FriendsPresentCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // return CGSize(width: screenWidth / 2 - 2, height: screenWidth / 2 - 2)
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + flowLayout.minimumInteritemSpacing
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(2))
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let current_present = presentArray[indexPath.row]
        let _ReservePresentVC = ReservePresentVC(nibName: "ReservePresentVC", bundle: nil)
        _ReservePresentVC.chosen_present = current_present
        _ReservePresentVC.modalPresentationStyle = .custom
        present(_ReservePresentVC, animated: true, completion: nil)
    }
}
