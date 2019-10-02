//
//  PhotosListTableViewCell.swift
//  FlikrApp
//
//  Created by Ankit Shrivastava on 16/05/19.
//  Copyright © 2019 Ankit Shrivastava. All rights reserved.
//

import UIKit

class PhotosListTableViewCell: UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet weak var imgFlickr: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    var objPhoto : Photo? {
        didSet {
            guard let photo = objPhoto else {
                return
            }
            
            lblTitle.text = photo.title
            
            ModuleManager.manager.loadImage(photo: photo, size: .square) { [weak self] (data) in
                guard let wSelf = self else {
                    return
                }
                
                if let data = data {
                    DispatchQueue.main.async {
                        wSelf.imgFlickr.image = UIImage(data: data)
                    }
                }else{
                    DispatchQueue.main.async {
                        wSelf.imgFlickr.image = nil
                    }
                }
            }
        }
    }
    
}
