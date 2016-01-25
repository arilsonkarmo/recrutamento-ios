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
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var lblRating: UILabel!
    
    var titleShow: String?
    var overview: String?
    var banner: NSURL?
    var rating: Float!
    
    
    @IBAction func btnClose(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        lblTitle.text = titleShow
        txtOverview.text = overview
        if banner != nil {
            imgBanner.image = UIImage(data: NSData(contentsOfURL: banner!)!)
        }
        
        lblRating.text = NSString(format: "%.1f/10", rating) as String
    }
}
