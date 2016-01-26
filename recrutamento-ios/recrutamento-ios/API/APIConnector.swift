//
//  APIConnector.swift
//  movile-test
//
//  Created by Arilson Carmo on 1/25/16.
//  Copyright © 2016 Arilson Carmo. All rights reserved.
//

import Foundation
import Alamofire

class APIConnector {
    var endpoint : String!
    var defaultHeaders: [String : String]!
    var limit = 0
    var page = 0

    init() {
        defaultHeaders = [
            "trakt-api-key": Constants.TraktCredentials.ClientId,
            "Content-Type": "application/json",
            "trakt-api-version": "2"
        ]
        endpoint = Constants.TraktAPI.BaseUrl
        limit = 30
    }
    
    private func createRequestPath(requestPath: String! ) -> String {
        if requestPath != nil {
            endpoint = endpoint + requestPath + "?extended=full%2Cimages&page=" + String(page) + "&limit=" + String(limit)
        }
        return endpoint
    }
    
    func getTrendingShows(increment: Bool, completionBlock: ([ShowsModel]?, NSError?) -> ()) {
        if increment {
            page = page + 1
        } else {
            page = 1
        }
        
        let request = createRequestPath("shows/trending")
        Alamofire.request(.GET, request, headers: defaultHeaders).responseJSON {
            response in
            switch response.result {
            case .Success:
                if  let entries = response.result.value as? [[String:AnyObject]] {
                    var list:[ShowsModel] = []
                    for entry in entries {
                        if let show = entry["show"] as? [String: AnyObject], s = ShowsModel(data: show) {
                            list.append(s)
                        }
                    }
                    completionBlock(list, nil)
                }
            case .Failure(let error):
                completionBlock(nil, error)
            }
        }
        
    }
    
}