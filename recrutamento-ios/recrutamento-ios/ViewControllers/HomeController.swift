//
//  ViewController.swift
//  movile-test
//
//  Created by Arilson Carmo on 1/25/16.
//  Copyright © 2016 Arilson Carmo. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh


public class HomeController: UICollectionViewController {
    
    let reuseIdentifier = "movieCell"
    let sectionInsets = UIEdgeInsets(top: 20.0, left: 15.0, bottom: 15.0, right: 10.0)
    let loadingView = DGElasticPullToRefreshLoadingViewCircle()
    let loader = GenericLoader()
    var shows: [ShowsModel]!
    var posterCache = NSCache()
    var loadingFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    
    override public func viewDidLoad() {
        loader.showSpinner(view)
        self.loadShows(true)
        self.loadingPullRefresh()
    }
    
    /*
    *  Load trending shows from Trakt API
    *  parameter: An boolean to increment page or not and dependency
    *  injecting to be turn an testable method.
    */
    func loadShows(increment: Bool, trakt: TraktManager = TraktManager()) {
        trakt.getTrendingShows(increment) { (result, error) -> Void in
            if let listShows = result {
                if self.shows != nil && increment == true {
                    self.shows.appendContentsOf(listShows)
                } else{
                    self.shows = listShows
                }
                self.collectionView?.reloadData()
                self.loader.hideSpinner()
            } else if let _ = error {
                self.loader.hideSpinner()
                GenericAlert().showAlert("Error", stringMessage: "Error on get the trending tv show list from the Trakt server. We will try to get again OK?",
                    completion: { () -> Void in
                    self.loader.showSpinner(self.view)
                    self.loadShows(false)
                })
            }
        }
    }
    
    /*
    * Loading pullRefresh lib in collectionView.
    */
    func loadingPullRefresh() {
        loadingView.tintColor = UIColor(white:1, alpha: 1)
        collectionView!.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.shows = nil
            self?.loadShows(false)
            self?.collectionView!.dg_stopLoading()
            }, loadingView: loadingView)
        collectionView!.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        collectionView!.dg_setPullToRefreshBackgroundColor(collectionView!.backgroundColor!)
    }
    
    override public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.shows?.count ?? 0
    }
    
    override public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        let title = cell.viewWithTag(1) as? UILabel
        let poster = cell.viewWithTag(2) as? UIImageView
        
        title?.text = self.shows[indexPath.row].title
        poster?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        if let url = self.shows[indexPath.row].imageURL(TraktImageType.Poster , size: TraktImageSize.Thumb) {
            let img = ShowsModel().getPosterCache(url)
            poster?.image = img
            if img == nil {
                ShowsModel().asyncLoadImageContent(url, completion: { (image) -> Void in
                    let ip =  collectionView.indexPathForCell(cell)
                    if indexPath.isEqual(ip) {
                        poster?.image = image
                    }
                })
            }
        }
        return cell
    }
    
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
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
    override public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if shows != nil && shows.count > 0 {
            let offsetY = scrollView.contentOffset.y;
            let contentHeight = scrollView.contentSize.height;
            if (offsetY > contentHeight - (scrollView.frame.size.height - 85))
            {
                loader.showSpinner(view)
                self.loadShows(true)
            }
        }
    }
    
    /*
    * Set default Edge insets on the collection view cells
    */
    public func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }

}



