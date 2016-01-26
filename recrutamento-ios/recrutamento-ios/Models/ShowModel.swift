//
//  ShowModel.swift
//  movile-test
//
//  Created by Arilson Carmo on 1/25/16.
//  Copyright © 2016 Arilson Carmo. All rights reserved.
//


import UIKit

private let downloadQueue = dispatch_queue_create("com.arilsoncarmo.movile-test", nil)
private var posterCache = NSCache()

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
        
        //Get images from shows and populate by type and size pair
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
    
    override init() {
        super.init()
    }
    
    /* 
    * Parse image link selected in NSURL 
    * Parameters: type of the image(enum) and Size of the image(enum)
    */
    func imageURL(type: TraktImageType, size: TraktImageSize) -> NSURL? {
        if let uri = images[type]?[size] {
            return NSURL(string: uri as! String)
        }
        return nil
    }
    
    func getPosterCache(urlKey: NSURL?) -> UIImage? {
        if let img = posterCache.objectForKey(urlKey!) as? UIImage {
            return img
        }
        return nil
    }
    
    /*
    *  Async method to load image..
    *  parameters: an url from image and callback to completion
    */
    func asyncLoadImageContent(imageURL: NSURL, completion: (image: UIImage) -> Void) {
        dispatch_async(downloadQueue) { () -> Void in
            if let data = NSData(contentsOfURL: imageURL) {
                let image = UIImage(data: data)
                dispatch_async(dispatch_get_main_queue()) {
                    posterCache.setObject(image!, forKey: imageURL)
                    completion(image: image!)
                }
            }
        }
    }
    
}