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

class PresentsVC: UIViewController, UIScrollViewDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    private let imageView = UIImageView(image: UIImage(named: "defaultProfilePicture")) // MARK: Change to User.Image
    var store = CNContactStore()
    var contacts = [CNContact]()
    var phoneNumbers = [String]()
    var filteredNumbers = [String]()
    
    let keys = [
        CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
        CNContactPhoneNumbersKey,
        CNContactEmailAddressesKey
        ] as [Any]
    
    // MARK: Profile Image Constants
    private struct Const {
        /// Image height/width for Large NavBar state
        static let ImageSizeForLargeState: CGFloat = 40
        /// Margin from right anchor of safe area to right anchor of Image
        static let ImageRightMargin: CGFloat = 16
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
        static let ImageBottomMarginForLargeState: CGFloat = 12
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
        static let ImageBottomMarginForSmallState: CGFloat = 6
        /// Image height/width for Small NavBar state
        static let ImageSizeForSmallState: CGFloat = 0
        /// Height of NavBar for Small state. Usually it's just 44
        static let NavBarHeightSmallState: CGFloat = 44
        /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
        static let NavBarHeightLargeState: CGFloat = 96.5
    }
    
    
    var presentArray = [Present]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        // imageView.isUserInteractionEnabled = true
        // imageView.addGestureRecognizer(tapGestureRecognizer)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.requestAccess { ( accessGranted ) in
            if accessGranted == true {
                self.getContacts()
                print(self.phoneNumbers)
                
                self.phoneNumbers = self.phoneNumbers.filter {
                    $0.contains("+")
                }
                for string in self.phoneNumbers {
                    let string_filtered = string.replacingOccurrences( of:"[^0-9]", with: "", options: .regularExpression)
                    self.filteredNumbers.append("+" + string_filtered)
                }
                
                print(self.filteredNumbers)
            } else {
                print("error")
            }
        }
        setUpView()
        getPresents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showImage(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showImage(true)
        setImage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchVCSegue" {
            if let vc = segue.destination as? SearchVC {
                vc.phoneNumbers = self.filteredNumbers
            }
        }
    }
    private func showImage(_ show: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.imageView.alpha = show ? 1.0 : 0.0
        }
    }
    
    func getContacts() {
        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        do {
            try store.enumerateContacts(with: request){
                (contact, stop) in
                // Array containing all unified contacts from everywhere
                self.contacts.append(contact)
                for phoneNumber in contact.phoneNumbers {
                    if let number = phoneNumber.value as? CNPhoneNumber, let label = phoneNumber.label {
                        let localizedLabel = CNLabeledValue<CNPhoneNumber>.localizedString(forLabel: label)
                        // print("\(contact.givenName) \(contact.familyName) tel:\(localizedLabel) -- \(number.stringValue), email: \(contact.emailAddresses)")
                        self.phoneNumbers.append(number.stringValue)
                    }
                }
            }
            // print(contacts)
        } catch {
            print("unable to fetch contacts")
        }
    }
    
    func requestAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            completionHandler(true)
        case .denied:
            showSettingsAlert(completionHandler)
        case .restricted, .notDetermined:
            store.requestAccess(for: .contacts) { granted, error in
                if granted {
                    completionHandler(true)
                } else {
                    DispatchQueue.main.async {
                        self.showSettingsAlert(completionHandler)
                    }
                }
            }
        }
    }
    
    private func showSettingsAlert(_ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let alert = UIAlertController(title: nil, message: "This app requires access to Contacts to proceed. Would you like to open settings and grant permission to contacts?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { action in
            completionHandler(false)
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            completionHandler(false)
        })
        present(alert, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        moveAndResizeImage(for: height)
        navigationItem.rightBarButtonItem?.tintColor? = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
        navigationItem.leftBarButtonItem?.tintColor? = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
    }
    
    func setUpView() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        
        navigationBar.addSubview(imageView)
        imageView.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Const.ImageRightMargin),
            imageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.ImageBottomMarginForLargeState),
            imageView.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
            ])
    }
    
    func setImage() {
        DataService.instance.getUserImg(forUid: Auth.auth().currentUser!.uid) { ( data ) in
            if data != nil {
                self.imageView.image = UIImage(data: data!)
            } else {
                self.imageView.image = UIImage(named: "defaultProfilePicture")
                print("error!")
            }
        }
    }
    
    /*
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        // MARK: Profile View Controller ??
        print("Profile Info")
    }
    */
    // MARK: Profile Image Animation
    private func moveAndResizeImage(for height: CGFloat) {
        let coeff: CGFloat = {
            let delta = height - Const.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (Const.NavBarHeightLargeState - Const.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()
        
        let factor = Const.ImageSizeForSmallState / Const.ImageSizeForLargeState
        
        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()
        
        // Value of difference between icons for large and small states
        let sizeDiff = Const.ImageSizeForLargeState * (1.0 - factor) // 8.0
        
        let yTranslation: CGFloat = {
            /// This value = 14. It equals to difference of 12 and 6 (bottom margin for large and small states). Also it adds 8.0 (size difference when the image gets smaller size)
            let maxYTranslation = Const.ImageBottomMarginForLargeState - Const.ImageBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (Const.ImageBottomMarginForSmallState + sizeDiff))))
        }()
        
        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)
        
        imageView.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
    }
    
    // MARK: Requires DB UPD
    @objc func getPresents() {
        if let user = Auth.auth().currentUser {
            DataService.instance.getPresents(forUid: user.uid) { ( returnedArray ) in
                if returnedArray.count == 0 {
                    // MARK: No Presents
                    self.getTestPresents()
                } else {
                    self.presentArray = returnedArray
                    self.collectionView.reloadData()
                }
            }
        } else {
            getTestPresents()
        }
    }
    
    @objc func getTestPresents() {
        TestDataService.instance.getPresent(forUid: "666") { ( returnedArray ) in
            self.presentArray = returnedArray
            self.collectionView.reloadData()
        }
    }
    
    // MARK: Toolbar Button Action
    @IBAction func addBtnPressed(_ sender: Any) {
        let _addPresentsVC = AddPresentsVC()
        _addPresentsVC.modalPresentationStyle = .custom
        present(_addPresentsVC, animated: true, completion: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getPresents), name: NSNotification.Name("PresentAdded"), object: nil)
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
            // print(uuid)
            if (img != "BackImg2" && img != "DefaultProfileImage") {
                DataService.instance.getPresentImg(forUid: (Auth.auth().currentUser?.uid)!, imageUrl: img) { ( imgData ) in
                    if imgData != nil {
                        cell.configureCell(name: name, price: price, details: details, imageName: imgData!)
                    } else {
                        let defImgData = UIImage(named: "BackImg2")!.jpegData(compressionQuality: 0.5)
                        cell.configureCell(name: name, price: price, details: details, imageName: defImgData!)
                    }
                }
            } else {
                let defImgData = UIImage(named: "BackImg2")!.jpegData(compressionQuality: 0.5)
                cell.configureCell(name: name, price: price, details: details, imageName: defImgData!)
            }
            
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
        return PresentCell()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presentArray.count
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
        // TODO: ADDITTIONAL PRESENT INFO APPEARENCE
        let current_present = presentArray[indexPath.row]
        let _presentInfoVC = PresentInfoVC(nibName: "PresentInfoVC", bundle: nil)
        _presentInfoVC.selected_item = current_present
        _presentInfoVC.modalPresentationStyle = .custom
        present(_presentInfoVC, animated: true, completion: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getPresents), name: NSNotification.Name("PresentDeleted"), object: nil)
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
