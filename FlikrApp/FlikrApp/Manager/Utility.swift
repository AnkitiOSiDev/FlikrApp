//
//  Utility.swift
//  FlikrApp
//
//  Created by Ankit Shrivastava on 17/05/19.
//  Copyright © 2019 Ankit Shrivastava. All rights reserved.
//

import Foundation
import UIKit
class Utility {
    static func getMainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    static func getPhotoDetailsController() -> PhotoDetailViewController {
        return getMainStoryboard().instantiateViewController(withIdentifier: PhotoDetailViewController.identifier) as! PhotoDetailViewController
    }
}
