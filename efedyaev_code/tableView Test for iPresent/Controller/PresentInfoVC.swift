//
//  PresentInfoVC.swift
//  tableView Test for iPresent
//
//  Created by Georg on 15.11.2018.
//  Copyright © 2018 Georg. All rights reserved.
//

import UIKit
import Firebase

class PresentInfoVC: UIViewController {
    
    @IBOutlet weak var presentPrice: UILabel!
    @IBOutlet weak var presentImg: UIImageView!
    @IBOutlet weak var presentName: UILabel!
    @IBOutlet weak var presentDescription: UILabel!
    
    @IBOutlet weak var deletePresentBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    public var selected_item: Present?
    let uid = Auth.auth().currentUser?.uid
    
    override func viewWillAppear(_ animated: Bool) {
        if selected_item != nil {
            presentName.text = selected_item!.name
            presentDescription.text = selected_item!.details
            presentPrice.text = selected_item!.price
            if let url = selected_item?.imageName {
                presentImg.loadImgWithURLString(urlString: url)
            }
        } else {
            print("error")
            return
        }
        cancelBtn.alpha = 0.75
        self.view.bringSubviewToFront(deletePresentBtn)
        presentImg.roundCorners([.bottomRight], radius: 75)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.sendSubviewToBack(blurEffectView)
        
//        deletePresentBtn.titleLabel?.text = "Delete Present".localized
//        cancelBtn.titleLabel?.text = "Cancel".localized
        deletePresentBtn.setTitle("Delete Present".localized, for: .normal)
        cancelBtn.setTitle("Cancel".localized, for: .normal)
        
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deletePresentBtnPressed(_ sender: Any) {
        showDeletePresentAlert()
    }
    
    func showDeletePresentAlert() {
        let alert = UIAlertController(title: "Delete present".localized, message: "Are you sure you want to delete present?".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes".localized, style: .destructive, handler: { [] (_) in
            _ = self.navigationController?.popViewController(animated: true)
            self.deletePresent()
        }))
        alert.addAction(UIAlertAction(title: "No".localized, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func deletePresent() {
        let key = selected_item!.uuid
        if key != "" {
            DataService.instance.removePresent(uid: uid!, uuid: key) { ( deleted ) in
                if deleted {
                    NotificationCenter.default.post(name: Notification.Name(Notifications.presentDeleted), object: nil)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
