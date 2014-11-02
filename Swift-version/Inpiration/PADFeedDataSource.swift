//
//  PADFeedDataSource.swift
//  Inpiration
//
//  Created by Alexander Hüllmandel on 11/1/14.
//  Copyright (c) 2014 Alexander Hüllmandel. All rights reserved.
//

import Foundation
import UIKit


class PADFeedDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    let CellIdentifier = "PADFeedCell"
    
    private lazy var array : Array<Dictionary<String, AnyObject>> = {
        let path = NSBundle.mainBundle().pathForResource("PADTiltViewControllerExample-Configuration", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        return dict!["feed"] as Array<Dictionary<String, AnyObject>>
    }()
    
    //MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.array.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = array[section] as Dictionary
        return sectionInfo.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as UITableViewCell
        let dict = array[indexPath.row]
        
        let textLabel = cell.viewWithTag(100) as? UILabel
        let detailTextField = cell.viewWithTag(101) as? UITextField
        let imageView = cell.viewWithTag(102) as? UIImageView
        
        textLabel?.text = dict["text"] as? String
        detailTextField?.text = dict["detailText"] as? String
        imageView?.image = UIImage(named: dict["imageName"] as String)
        
        return cell;
    }
    
//MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        let dict = self.array[indexPath.row]
//        let heightKey = "heigth"
//        let heightDict = dict[heightKey] as Dictionary<String,
//        let deviceKey = (UIDevice.currentDevice().userInterfaceIdiom == .Phone) ? "phone" : "pad"
        return 88.0
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}