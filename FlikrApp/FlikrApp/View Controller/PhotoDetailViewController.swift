//
//  PhotoDetailViewController.swift
//  FlikrApp
//
//  Created by Ankit Shrivastava on 17/05/19.
//  Copyright © 2019 Ankit Shrivastava. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    static let identifier = "PhotoDetailViewController"
    
    @IBOutlet weak var imgViewBackground: UIImageView!
    @IBOutlet weak var imgViewForeGround: UIImageView!
    var photo : Photo?
    
    @IBOutlet weak var lblTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - View Setup
    func setupUI(){
        guard let photo = photo else{
            return
        }
        lblTitle.text = photo.title
        ModuleManager.manager.loadImage(photo: photo, size: .large) { [weak self] (data) in
            guard let wSelf = self else{
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    wSelf.imgViewBackground.image = UIImage(data: data)
                    wSelf.imgViewForeGround.image = UIImage(data: data)
                }
            }
        }
    }
    
    @IBAction func btnCloseDidClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
