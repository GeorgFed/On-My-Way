//
//  ContactsService.swift
//  tableView Test for iPresent
//
//  Created by Georg on 24/03/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import UIKit
import Firebase
import Contacts
import ContactsUI
import PhoneNumberKit

class ContactsService {
    static let instance = ContactsService()
    
    let uid = Auth.auth().currentUser?.uid
    let keys = [
        CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
        CNContactPhoneNumbersKey,
        CNContactEmailAddressesKey
        ] as [Any]
    
    var store = CNContactStore()
    var contacts = [CNContact]()
    var phoneNumbers = [String]()
    var filteredNumbers = [String]()
    
    func getPhoneNumbers(on controller: UIViewController, handler: @escaping(_ filteredNumbers: [String], _ success: Bool) -> ()) {
        self.requestAccess(on: controller) { ( accessGranted ) in
            if accessGranted == true {
                self.getContacts()
                // print(self.phoneNumbers)
                self.phoneNumbers = self.phoneNumbers.filter {
                    $0.contains("+")
                }
                for string in self.phoneNumbers {
                    let string_filtered = string.replacingOccurrences( of:"[^0-9]", with: "", options: .regularExpression)
                    self.filteredNumbers.append("+" + string_filtered)
                }
                handler(self.filteredNumbers, true)
                // print(self.filteredNumbers)
            } else {
                handler(self.filteredNumbers, false)
            }
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
                        self.phoneNumbers.append(number.stringValue)
                    }
                }
            }
        } catch {
            print("unable to fetch contacts")
        }
    }
    
    func requestAccess(on controller: UIViewController, completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            completionHandler(true)
        case .denied:
            self.showSettingsAlert(on: controller, completionHandler)
        case .restricted, .notDetermined:
            store.requestAccess(for: .contacts) { granted, error in
                if granted {
                    completionHandler(true)
                } else {
                    DispatchQueue.main.async {
                        self.showSettingsAlert(on: controller, completionHandler)
                    }
                }
            }
        }
    }
    
    private func showSettingsAlert(on controller: UIViewController, _ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let alert = UIAlertController(title: nil,
                                      message: "This app requires access to Contacts to proceed. Would you like to open settings and grant permission to contacts?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { action in
            completionHandler(false)
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            completionHandler(false)
        })
        controller.present(alert, animated: true, completion: nil)
    }
}
