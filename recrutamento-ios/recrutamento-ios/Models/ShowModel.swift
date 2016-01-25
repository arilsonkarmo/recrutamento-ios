//
//  ShowModel.swift
//  movile-test
//
//  Created by Arilson Carmo on 1/25/16.
//  Copyright © 2016 Arilson Carmo. All rights reserved.
//

import Foundation

class ShowsModel : NSObject {
    var title: String!
    var overview: String?
    var rating: Float?
    var runtime: Int?
    var homepage: String?
    var genres: [String]?
    var images: [TraktImageType:[TraktImageSize:AnyObject]] = [:]
    
    init?(data: [String: AnyObject]!){
        title = data?["title"] as? String
        overview = data?["overview"] as? String
        rating = data?["rating"] as? Float ?? nil
        runtime = data?["runtime"] as? Int
        homepage = data?["homepage"] as? String ?? nil
        genres = data?["genres"] as? [String]
        
        if let im = data?["images"] as? [String:AnyObject] {
            for (rawType, list) in im {
                if let type = TraktImageType(rawValue: rawType), listed = list as? [String: AnyObject]  {
                    for (rawSize, uri) in listed {
                        if let size = TraktImageSize(rawValue: rawSize), u = uri as? String  {
                            if images[type] == nil {
                                images[type] = [:]
                            }
                            images[type]![size] = u
                        }
                    }
                }
            }
        }
    }
    
    func imageURL(type: TraktImageType, size: TraktImageSize) -> NSURL? {
        if let uri = images[type]?[size] {
            return NSURL(string: uri as! String)
        }
        return nil
    }

    
    
}