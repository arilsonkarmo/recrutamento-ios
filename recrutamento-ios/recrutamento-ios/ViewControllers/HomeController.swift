//
//  ViewController.swift
//  movile-test
//
//  Created by Arilson Carmo on 1/25/16.
//  Copyright © 2016 Arilson Carmo. All rights reserved.
//

import UIKit

private let downloadQueue = dispatch_queue_create("com.arilsoncarmo.movile-test", nil)

class HomeController: UICollectionViewController {
    
    let reuseIdentifier = "movieCell"
    let sectionInsets = UIEdgeInsets(top: 20.0, left: 15.0, bottom: 15.0, right: 10.0)
    var trakt = TraktManager()
    var shows: [ShowsModel]!
    var posterCache = NSCache()
    var loadingFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        loadShows(true)
    }
    
    /*
    *  Load trending shows from Trakt API
    *  parameter: An boolean to increment page or not.
    */
    func loadShows(increment: Bool) {
        self.showLoaderSpinner(true)
        trakt.getTrendingShows (increment) { (result, error) -> Void in
            if let listShows = result {
            if self.shows != nil {
                self.shows.appendContentsOf(listShows)
            } else{
                self.shows = listShows
            }
                
                self.collectionView?.reloadData()
                self.showLoaderSpinner(false)
            } else if let _ = error {
                self.showLoaderSpinner(false)
                GenericAlert().showAlert("Error", stringMessage: "Error on get Trakt Show List. We will try to get the show list again OK?",
                    completion: { () -> Void in
                    self.loadShows(false)
                })
            }
        }
    }
    
    /* 
     *  Show load spiner on center of the view.
     *  parameter: boolean show spinner (true), remove spinner(false)
    */
    func showLoaderSpinner(show:Bool) {
        if show {
            loadingFrame = UIView(frame: CGRect(x: view.frame.midX - 40, y: view.frame.midY - 40 , width: 80, height: 80))
            loadingFrame.layer.cornerRadius = 15
            loadingFrame.backgroundColor = UIColor(white: 0, alpha: 0.8)
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            activityIndicator.startAnimating()
            loadingFrame.addSubview(activityIndicator)
            view.addSubview(loadingFrame)
        } else {
            loadingFrame.removeFromSuperview()
        }
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.shows?.count ?? 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        let title = cell.viewWithTag(1) as? UILabel
        let poster = cell.viewWithTag(2) as? UIImageView
        
        title?.text = self.shows[indexPath.row].title
        poster?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        if let url = self.shows[indexPath.row].imageURL(TraktImageType.Poster , size: TraktImageSize.Thumb) {
            let img = posterCache.objectForKey(url) as? UIImage
            poster?.image = img
            
            if img == nil {
                asyncLoadImageContent(url, completion: { (image) -> Void in
                    let ip =  collectionView.indexPathForCell(cell)
                    if indexPath.isEqual(ip) {
                        poster?.image = image
                    }
                })
            }
        }
        return cell
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
                    self.posterCache.setObject(image!, forKey: imageURL)
                    completion(image: image!)
                }
            }
        }
    }
        
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? OverviewController {
            if let indexPath = collectionView?.indexPathsForSelectedItems() {
                destination.titleShow = self.shows[indexPath[0].row].title
                destination.overview = self.shows[indexPath[0].row].overview
                destination.rating = self.shows[indexPath[0].row].rating
                destination.banner = self.shows[indexPath[0].row].imageURL(TraktImageType.Banner , size: TraktImageSize.Full)
            }
        }
    }
    
    /*
    *  Async method to load image..
    *  parameters: an url from image and callback to completion
    */
    override func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if shows != nil && shows.count > 0 {
            let offsetY = scrollView.contentOffset.y;
            let contentHeight = scrollView.contentSize.height;
            if (offsetY > contentHeight - (scrollView.frame.size.height - 85))
            {
                loadShows(true)
            }
        }
    }
}

extension HomeController : UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
}


