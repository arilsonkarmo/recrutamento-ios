//
//  GenericLoader.swift
//  recrutamento-ios
//
//  Created by Arilson Carmo on 1/25/16.
//  Copyright © 2016 Arilson Carmo. All rights reserved.
//

import UIKit

class GenericLoader {
    var loadingFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    /*
    *  Show load spinner on center of the view.
    */
    func showSpinner(view: UIView) {
        if !loadingFrame.isDescendantOfView(view) {
            loadingFrame = UIView(frame: CGRect(x: view.frame.midX - 40, y: view.frame.midY - 40 , width: 80, height: 80))
            loadingFrame.layer.cornerRadius = 15
            loadingFrame.backgroundColor = UIColor(white: 0, alpha: 0.8)
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            activityIndicator.startAnimating()
            loadingFrame.addSubview(activityIndicator)
            view.addSubview(loadingFrame)
        }
    }
    
    /*
    *  Hide load spinner
    */
    func hideSpinner() {
        loadingFrame.removeFromSuperview()
    }
}