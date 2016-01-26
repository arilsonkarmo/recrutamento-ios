//
//  OverviewController.swift
//  movile-test
//
//  Created by Arilson Carmo on 1/25/16.
//  Copyright © 2016 Arilson Carmo. All rights reserved.
//

import UIKit

class OverviewController: UIViewController {
    
    @IBOutlet weak var txtOverview: UITextView!
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var navTitle: UINavigationItem!
    
    var titleShow: String?
    var overview: String?
    var banner: NSURL?
    var rating: Float!
    
    override func viewWillAppear(animated: Bool) {
        navTitle.title = titleShow
        txtOverview.text = overview
        if banner != nil {
            imgBanner.image = UIImage(data: NSData(contentsOfURL: banner!)!)
        }
    }
}
