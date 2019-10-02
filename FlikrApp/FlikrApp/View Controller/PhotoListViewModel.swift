//
//  PhotoListViewModel.swift
//  FlikrApp
//
//  Created by Ankit Shrivastava on 16/05/19.
//  Copyright © 2019 Ankit Shrivastava. All rights reserved.
//

import Foundation

protocol PhotoListDelegate : AnyObject {
    func dateFetched()
}

class PhotoListViewModel {
    
    weak var delegate : PhotoListDelegate!
    var photosModel : PhotosDataModel?
    
    init(delegate: PhotoListDelegate) {
        self.delegate = delegate
    }
    
    func getPhotos(text: String) {
        ModuleManager.manager.getPhotos(text: text, page: (photosModel?.photos.page ?? 0 + 1)) { [weak self] (response) in
            guard let wSelf = self else{
                return
            }
            switch response {
            case .success(let model):
                wSelf.photosModel = model as? PhotosDataModel
                wSelf.delegate.dateFetched()
            case .failure(_):
                break
            }
        }
    }
}
