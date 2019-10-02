//
//  NetworkManager.swift
//  FlikrApp
//
//  Created by Ankit Shrivastava on 16/05/19.
//  Copyright © 2019 Ankit Shrivastava. All rights reserved.
//

import Foundation

enum Result<T,U> {
    case success(T)
    case failure(U)
}

enum HTTPMethod {
    case GET
    case POST
    
    var type : String {
        switch self {
        case .GET:
            return "GET"
        case .POST:
            return "POST"
        }
    }
}

enum AppError : Error {
    case invalidParams
    case invalidUrl
    case invalidStautsCode
    case invalidResponse
}

let imageCache = NSCache<NSString, AnyObject>()
typealias responseHandler = (Result<Any,Error>) -> Void

class NetworkManager {
    static let manager = NetworkManager()
    
    private init(){
    }
    
    /**
     This method is used for making the network calls.
     - Parameter  header:  Header fields required for the request.
     - Parameter  url:  url of the request.
     - Parameter  payload: parameters needed for the query.
     - Parameter httpMethod: httpMethod used to get the protocol.
     - Parameter isImage: Check if image to be downloaded.
     - Parameter completion: invoked when network call completed.
     - Returns:  No value.
     */
    func networkCall(header:[String:String] = [:],url:String,payload:[String:Any],httpMethod:HTTPMethod ,isImage:Bool = false, completion:@escaping responseHandler) {
        
        var headerFields : [String:String] = ["Cache-Control":"private"]
        
        
        for (key,value) in header {
            headerFields[key] = value
        }
        
        var urlPath = url
        var postData : Data?
        
        switch httpMethod {
        case .GET:
            if let payLoad = payload as? [String:String] {
                urlPath += "?" + makeQuery(payload: payLoad)
            }else{
                completion(.failure(AppError.invalidParams))
                return
            }
        case .POST:
            do {
                 postData = try JSONSerialization.data(withJSONObject: payload, options: [])
            } catch{
                completion(.failure(AppError.invalidParams))
                return
            }
            break
        }
        
        
        guard let url = URL(string: urlPath)  else {
            completion(.failure(AppError.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy
            , timeoutInterval: 60.0)
        request.allHTTPHeaderFields = headerFields
        request.httpMethod = httpMethod.type
        if let body = postData {
            request.httpBody = body
        }
       
        
        
        if isImage {
            if let cachedImage = imageCache.object(forKey: urlPath as NSString) as? Data {
                completion(.success(cachedImage))
                return
            }
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse, let data = data {
                if response.statusCode == 200 {
                    if isImage {
                        imageCache.setObject(data as AnyObject, forKey: urlPath as NSString)
                    }
                    completion(.success(data))
                }else{
                    completion(.failure(AppError.invalidStautsCode))
                }
            }else{
                
            }
            }.resume()
        
    }
    
/**
   This method is used for making makeQuery for get call.
 - Parameter  payload:  parameters required for the query.
 - Return : The query for url request.
 */
    private func makeQuery(payload: [String:String]) -> String {
        var query : [String] = []
        for (key,value) in payload {
            if let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                query.append(key + "=" + encodedValue)
            }
        }
        return query.isEmpty ? "" : query.joined(separator: "&")
    }
    
    
}
