//
//  TraktManager.swift
//  movile-test
//
//  Created by Arilson Carmo on 1/25/16.
//  Copyright © 2016 Arilson Carmo. All rights reserved.
//

import Foundation

class TraktManager {
    var connector = APIConnector()
    
    func getTrendingShows(increment: Bool, completion: ([ShowsModel]?, NSError?) -> Void) {
        connector.getTrendingShows(increment, completionBlock: { (shows ,error) -> () in
            completion(shows, error)
        })
    }
    
}