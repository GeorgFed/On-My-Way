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
    
    public var selected_item: Present?
    let uid = Auth.auth().currentUser?.uid
    
    override func viewWillAppear(_ animated: Bool) {
        
        if selected_item != nil {
            presentName.text = selected_item!.name
            presentDescription.text = selected_item!.details
            presentImg.image = UIImage(named: selected_item!.imageName)
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
    
    @IBAction func deletePresentBtnPressed(_ sender: Any) {
        let key = selected_item!.uuid
        if key != "" {
            DataService.instance.removePresent(uid: uid!, uuid: key) { ( deleted ) in
                if deleted {
                    NotificationCenter.default.post(name: Notification.Name("PresentDeleted"), object: nil)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
}
