//
//  PADCrawlDataSource.swift
//  Inpiration
//
//  Created by Alexander Hüllmandel on 10/31/14.
//  Copyright (c) 2014 Alexander Hüllmandel. All rights reserved.
//

import Foundation
import UIKit


class PADCrawlDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    let CellIdentifier = "PADCrawlCell"

    private lazy var array : Array<Array<String>> = {
        let path = NSBundle.mainBundle().pathForResource("PADTiltViewControllerExample-Configuration", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
            return dict!["crawl"] as Array<Array<String>>
    }()
    
//MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.array.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = array[section] as Array
        return sectionInfo.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as UITableViewCell
        cell.textLabel.text = array[indexPath.section][indexPath.row]
        return cell
    }
    
//MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}