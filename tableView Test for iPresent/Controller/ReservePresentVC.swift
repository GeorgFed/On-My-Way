//
//  ReservePresentVC.swift
//  tableView Test for iPresent
//
//  Created by Georg on 16.11.2018.
//  Copyright © 2018 Georg. All rights reserved.
//

import UIKit

class ReservePresentVC: UIViewController {

    @IBOutlet weak var presentImg: UIImageView!
    @IBOutlet weak var presentName: UILabel!
    @IBOutlet weak var presentDescription: UILabel!
    
    var chosen_present: Present?
    
    override func viewWillAppear(_ animated: Bool) {
        if chosen_present != nil {
            presentName.text = chosen_present!.name
            presentDescription.text = chosen_present!.details
            // presentImg.image = UIImage(named: chosen_present!.imageName)
            /*
            if (chosen_present!.imageName != "BackImg2" && chosen_present!.imageName != "DefaultProfileImage") {
                    DataService.instance.getUserImgForURL(forURL: chosen_present!.imageName) { (data) in
                        if data != nil {
                            self.presentImg.image = UIImage(data: data!)
                        } else {
                            print("error!!")
                        }
                    }
                } else {
                    presentImg.image = UIImage(named: chosen_present!.imageName)
                }
        } else {
            print("error")
            return
        }
             */
            if let url = chosen_present?.imageName {
                presentImg.loadImgWithURLString(urlString: url)
            }
        }
        
//        if selected_item != nil {
//            presentName.text = selected_item!.name
//            presentDescription.text = selected_item!.details
//            if (selected_item!.imageName != "BackImg2" && selected_item!.imageName != "DefaultProfileImage") {
//                DataService.instance.getUserImgForURL(forURL: selected_item!.imageName) { (data) in
//                    if data != nil {
//                        self.presentImg.image = UIImage(data: data!)
//                    } else {
//                        print("error!!")
//                    }
//                }
//            } else {
//                presentImg.image = UIImage(named: selected_item!.imageName)
//            }
//        } else {
//            print("error")
//            return
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView() {
        // Method #1
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.sendSubviewToBack(blurEffectView)
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reservePresentBtnPressed(_ sender: Any) {
        if chosen_present != nil {
            print(chosen_present!.link)
            if let url = URL(string: chosen_present!.link) {
                print(url)
                UIApplication.shared.open(url, options: [:]) { (success) in
                    if success {
                        print("success")
                    } else {
                        self.showAlert()
                    }
                }
            } else {
                showAlert()
            }
        } else {
            showAlert()
        }
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Error", message: "Cannot access link!", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
}
