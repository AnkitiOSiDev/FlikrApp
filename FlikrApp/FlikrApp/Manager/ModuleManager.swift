//
//  ModuleManager.swift
//  FlikrApp
//
//  Created by Ankit Shrivastava on 16/05/19.
//  Copyright © 2019 Ankit Shrivastava. All rights reserved.
//

import Foundation

class ModuleManager {
    
    static let manager = ModuleManager()
    private var networkManager : NetworkManager
    private init(){
        networkManager = NetworkManager.manager
    }
    
    /**
     This method is used search the photos.
     - Parameter  text:  The title to search the image.
     - Parameter  page:  Next page number to be fetched (Optional).
     - Parameter completion: Invoked when photos fetched.
     - Returns:  No value.
     */
    
    func getPhotos(text: String,page: Int?, completion: @escaping responseHandler){
        var payload : [String:String] = [:]
        
        payload["method"] = "flickr.photos.search"
        payload["api_key"] = ApiKeys.key
        payload["text"] = text
        payload["format"] = "json"
        payload["per_page"] = "100"
        payload["nojsoncallback"] = "1"
        
        if let page = page {
            payload["page"] = String(page)
        }else{
            payload["page"] = "1"
        }
        
        networkManager.networkCall(url: ApiPath.baseUrl, payload: payload, httpMethod: .GET) { (response) in
            switch response {
            case .success(let data):
                do {
                    let photo = try JSONDecoder().decode(PhotosDataModel.self, from: data as! Data)
                    completion(.success(photo))
                    return
                }catch {
                    completion(.failure(AppError.invalidResponse))
                    return
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /**
     This method is used to load the photo from Network (Caching enabled).
     - Parameter  photo:  Photo objects contains image information.
     - Parameter  size:  Size of the image to be fetched.
     - Parameter completion: Invoked when photos downloaded.
     - Parameter imageData: Downloaded image data .
     - Returns:  No value.
     */
    
    func loadImage(photo: Photo,size: PhotoSize , completion: @escaping (_ imageData : Data?) -> Void)  {
        var url = "https://"
        url.append("farm\(photo.farm)")
        url.append(".staticflickr.com")
        url.append("/\(photo.server)")
        url.append("/\(photo.idPhoto)")
        url.append("_\(photo.secret)")
        url.append("_\(size.type)")
        url.append(".jpg")
        
        networkManager.networkCall(url: url, payload:[:], httpMethod: .GET, isImage: true) { (response) in
            switch response {
            case .success(let data):
                completion(data as? Data)
            case .failure(_):
                completion(nil)
            }
        }
    }
}
