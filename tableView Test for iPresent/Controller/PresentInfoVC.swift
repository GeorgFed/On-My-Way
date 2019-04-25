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
            if let url = selected_item?.imageName {
                presentImg.loadImgWithURLString(urlString: url)
            }
        } else {
            print("error")
            return
        }
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
