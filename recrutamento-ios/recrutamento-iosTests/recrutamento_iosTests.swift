//
//  recrutamento_iosTests.swift
//  recrutamento-iosTests
//
//  Created by Arilson Carmo on 1/25/16.
//  Copyright © 2016 Arilson Carmo. All rights reserved.
//

import XCTest
import UIKit
import recrutamento_ios

class recrutamento_iosTests: XCTestCase {
    
    var vc: HomeController!
    
    class FakeTraktManager: TraktManager {
        var getShowsWasCalled = false
        var result: [ShowsModel]? = [ShowsModel(data: ["title":"bla", "images" : ["poster" : "full"]])!]
        
        override func getTrendingShows(increment: Bool, completion: ([ShowsModel]?, NSError?) -> Void) {
            getShowsWasCalled = true
            completion(result, nil)
        }
        
    }
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main",
            bundle: NSBundle(forClass: self.dynamicType))
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        vc = navigationController.topViewController as! HomeController
        
        UIApplication.sharedApplication().keyWindow!.rootViewController = vc
        
        
    }
    
    func testShowPopulating() {
        let fakeTraktManager = FakeTraktManager()
        
        vc.loadShows(true, trakt: fakeTraktManager)
        XCTAssertTrue(fakeTraktManager.getShowsWasCalled)
        
        if let dataSource = vc.shows {
            XCTAssertEqual(fakeTraktManager.result!, dataSource)
        } else {
            XCTFail("Data Source should not be nil!!!")
        }
    }
    
    func testAsyncLoadImages() {
        let showsModel = ShowsModel()
        let url = NSURL(string: "http://densta-panels.com/wp-content/uploads/2014/02/test1.jpg")
        showsModel.asyncLoadImageContent(url!) { (image) -> Void in
            if let _ = self.vc.posterCache.objectForKey(url!) as? UIImage {
                XCTAssertTrue(true, "image saved in cache")
            } else {
                XCTFail("Cannot be save image in cache")
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
