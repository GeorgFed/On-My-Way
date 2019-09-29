//
//  CacheExtension.swift
//  tableView Test for iPresent
//
//  Created by Georg on 08/01/2019.
//  Copyright © 2019 Georg. All rights reserved.
//

import UIKit

let userKey = "mainUser"

public let imageCache = NSCache<NSString, UIImage>()
public let mainUserPhotoURLCache = NSCache<NSString, NSString>()
public let mainUserNameCache = NSCache<NSString, NSString>()
