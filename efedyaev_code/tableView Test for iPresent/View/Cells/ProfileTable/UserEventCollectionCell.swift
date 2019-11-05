//
//  UserEventCollectionCell.swift
//  tableView Test for iPresent
//
//  Created by Georg on 10/10/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import UIKit

class UserEventCollectionCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let reuseIDs = ["add", "event"]
    var events = [Event]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configureCell(events: [Event]) {
        self.events = events
        self.collectionView.reloadData()
        print("Количество событий: \(self.events.count)")
        for i in events {
            print(i)
        }
    }
}

extension UserEventCollectionCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(events.count)
        return events.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell: AddEventCollectionCell! = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIDs[0], for: indexPath) as? AddEventCollectionCell
            let glyph = UIImage(named: "AddEventBtn")
            cell.configureCell(title: "Add Event", addGlyph: glyph!)
            
            cell.contentView.backgroundColor = #colorLiteral(red: 0.9137254902, green: 0.3921568627, blue: 0.631372549, alpha: 1)
            
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
        } else {
            let cell: EventCollectionCell! = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIDs[1], for: indexPath) as? EventCollectionCell
//            cell.name.text = events[indexPath.row - 1].title
//            cell.day.text = events[indexPath.row - 1].day
//            cell.month.text = events[indexPath.row - 1].month
            print("array name \(events[indexPath.row - 1].title)")
            cell.configureCell(name: events[indexPath.row - 1].title, day: events[indexPath.row - 1].day, month: events[indexPath.row - 1].month)
            cell.contentView.backgroundColor = ColorKeys.red
            
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
        if indexPath.row == 0 {
            let _addEventVC = AddEventVC()
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                topController.present(_addEventVC, animated: true, completion: nil)
            }
            
        }
    }
    
}


extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}
