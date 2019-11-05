//
//  PresentCollectionCell.swift
//  tableView Test for iPresent
//
//  Created by Georg on 21/03/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import UIKit

class PresentCollectionCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    var friend: User!
    var presentArray = [Present]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    public func configureCollectionCell(f: User) {
        self.friend = f
        getPresents()
    }
    
    func getPresents() {
        DataService.instance.getPresents(forUid: friend.uid) { (presents) in
            self.presentArray = presents
            self.collectionView.reloadData()
        }
    }
}

extension PresentCollectionCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presentArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PresentEventCollectionCell", for: indexPath) as? PresentEventCollectionCell {
            let name = presentArray[indexPath.row].name
            let details = presentArray[indexPath.row].details
            let price = presentArray[indexPath.row].price
            let img = presentArray[indexPath.row].imageName
            cell.configureCell(name: name, details: details, price: price, imageUrl: img)
            
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
        return FriendsPresentCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
        _ReservePresentVC.modalPresentationStyle = .pageSheet
        DispatchQueue.main.async {
            self.getTopMostViewController()?.present(_ReservePresentVC, animated: true, completion: nil)
        }
    }
    
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        
        return topMostViewController
    }
}
