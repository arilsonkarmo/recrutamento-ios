//
//  TraktManager.swift
//  movile-test
//
//  Created by Arilson Carmo on 1/25/16.
//  Copyright © 2016 Arilson Carmo. All rights reserved.
//

import Foundation

private var connector = APIConnector()

class TraktManager {
    
    /*
    * Get list of trending shows from TraktAPI
    * Parameters: increment: to increment page result in list and completion.
    */
    func getTrendingShows(increment: Bool, completion: ([ShowsModel]?, NSError?) -> Void) {
        connector.getTrendingShows(increment, completionBlock: { (shows ,error) -> () in
            completion(shows, error)
        })
    }
    
}