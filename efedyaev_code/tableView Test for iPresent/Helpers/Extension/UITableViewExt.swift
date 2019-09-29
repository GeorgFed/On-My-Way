//
//  UITableViewExt.swift
//  tableView Test for iPresent
//
//  Created by Georg on 21/03/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import UIKit

// Extension for EMPTY_TABLEVIEW case

enum ConditionImages: String {
    case noEvents = "no_events_alert"
    case noPresents = "no_presents_alert"
    case noFriends = "no_friends_alert"
    case noInternet = "Internet_ERROR"
    case noResults = "search_error"
    case unknown = "unknown_error"
}

extension UITableView {
    func setEmptyView(title: String, message: String, alertImage: ConditionImages) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        emptyView.backgroundColor = .white
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        let imageName = alertImage.rawValue
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if alertImage == .noInternet || alertImage == .noResults || alertImage == .unknown {
            titleLabel.font = UIFont(name: "AvenirNext-Medium", size: 24)
            titleLabel.textColor = UIColor.lightGray
        } else {
            titleLabel.font = UIFont(name: "AvenirNext-Regular", size: 24)
            titleLabel.textColor = UIColor.black
        }
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "AvenirNext-Regular", size: 16)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        emptyView.addSubview(imageView)
        
        imageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -56).isActive = true
        imageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    func restore() {
        self.backgroundView = nil
    }
}

extension UICollectionView {
    func setEmptyView(title: String, message: String, alertImage: ConditionImages) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        emptyView.backgroundColor = .white
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        let imageName = alertImage.rawValue
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if alertImage == .noInternet || alertImage == .noResults || alertImage == .unknown {
            titleLabel.font = UIFont(name: "AvenirNext-Medium", size: 24)
            titleLabel.textColor = UIColor.lightGray
        } else {
            titleLabel.font = UIFont(name: "AvenirNext-Regular", size: 24)
            titleLabel.textColor = UIColor.black
        }
        
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "AvenirNext-Regular", size: 16)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        emptyView.addSubview(imageView)
        
        imageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -56).isActive = true
        imageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        self.backgroundView = emptyView
    }
    func restore() {
        self.backgroundView = nil
    }
}
