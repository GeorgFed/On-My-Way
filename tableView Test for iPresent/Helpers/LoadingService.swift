//
//  LoadingService.swift
//  tableView Test for iPresent
//
//  Created by Georg on 21/08/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import UIKit

class LoadingService {
    static let instance = LoadingService()
    
    /// View which contains the loading text and the spinner
    let loadingView = UIView()
    /// Spinner shown during load the TableView
    let spinner = UIActivityIndicatorView()
    /// Text shown during load the TableView
    let loadingLabel = UILabel()

    public func setLoadingScreen(collectionView: UICollectionView, navHeight: CGFloat) {
        print("Loading screen is set")
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (collectionView.frame.width / 2) - (width / 2)
        // let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        let y = (collectionView.frame.height / 2) - (height / 2) - navHeight
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        // Sets loading text
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = ""
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
        // Sets spinner
        
        spinner.style = .gray
        spinner.frame = CGRect(x: (loadingView.frame.width / 2) - 15, y: 0, width: 30, height: 30)
        spinner.startAnimating()
        // Adds text and spinner to the view
        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)
        collectionView.addSubview(loadingView)
    }
    
    // Set the activity indicator into the main view
    public func setLoadingScreen(tableView: UITableView, navHeight: CGFloat) {
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2) - (width / 2)
        // let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        let y = (tableView.frame.height / 2) - (height / 2) - navHeight
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        // Sets loading text
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = ""
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
        // Sets spinner
        spinner.style = .gray
        spinner.frame = CGRect(x: (loadingView.frame.width / 2) - 15, y: 0, width: 30, height: 30)
        spinner.startAnimating()
        // Adds text and spinner to the view
        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)
        tableView.addSubview(loadingView)
    }
    
    // Remove the activity indicator from the main view
    public func removeLoadingScreen() {
        // Hides and stops the text and the spinner
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
    }
}
