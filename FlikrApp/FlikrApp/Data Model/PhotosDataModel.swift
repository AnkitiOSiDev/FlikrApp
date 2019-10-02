//
//  PhotoDataModel.swift
//  FlikrApp
//
//  Created by Ankit Shrivastava on 16/05/19.
//  Copyright © 2019 Ankit Shrivastava. All rights reserved.
//

import Foundation

enum PhotoSize {
    case square
    case large
    
    var type : String {
        switch self {
            
        case .square:
            return "q" // large square 150x150
        case .large:
            return "b" // large, 1024 on longest side*
        }
    }
}


struct PhotosDataModel: Decodable  {
    var photos : Photos
    
    enum CodingKeys: String, CodingKey {
        case photos = "photos"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        photos = try container.decode(Photos.self, forKey: CodingKeys.photos)
    }
    
}

struct Photos: Decodable {
    var page : Int
    var pages : Int
    var perPage : Int
    var total : String
    var photo : [Photo]
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case pages = "pages"
        case perPage = "perpage"
        case total = "total"
        case photo = "photo"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        page = try container.decode(Int.self, forKey: CodingKeys.page)
        pages = try container.decode(Int.self, forKey: CodingKeys.pages)
        perPage = try container.decode(Int.self, forKey: CodingKeys.perPage)
        total = try container.decode(String.self, forKey: CodingKeys.total)
        photo = try container.decode([Photo].self, forKey: CodingKeys.photo)
    }
    
}

struct Photo: Decodable {
    var idPhoto : String = ""
    var owner : String = ""
    var secret : String = ""
    var server : String = ""
    var farm : Int = 0
    var title : String = ""
    
    enum CodingKeys: String, CodingKey {
        case idPhoto = "id"
        case owner   = "owner"
        case secret  = "secret"
        case server  = "server"
        case farm    = "farm"
        case title   = "title"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        idPhoto = try container.decode(String.self, forKey: CodingKeys.idPhoto)
        owner = try container.decode(String.self, forKey: CodingKeys.owner)
        secret = try container.decode(String.self, forKey: CodingKeys.secret)
        server = try container.decode(String.self, forKey: CodingKeys.server)
        farm = try container.decode(Int.self, forKey: CodingKeys.farm)
        title = try container.decode(String.self, forKey: CodingKeys.title)
    }
}
