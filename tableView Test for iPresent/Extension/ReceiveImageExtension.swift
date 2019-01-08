//
//  receiveImageExtension.swift
//  tableView Test for iPresent
//
//  Created by Georg on 08/01/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadImgWithURLString(urlString: String) {
        self.image = nil
        if let cachedImg = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImg
            return
        }
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url! ) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                if let img = UIImage(data: data!) {
                    imageCache.setObject(img, forKey: urlString as NSString)
                    self.image = img
                }
                
            }
        }.resume()
    }
}

