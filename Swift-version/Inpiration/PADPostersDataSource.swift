//
//  PADPostersDataSource.swift
//  Inpiration
//
//  Created by Alexander Hüllmandel on 11/1/14.
//  Copyright (c) 2014 Alexander Hüllmandel. All rights reserved.
//

import Foundation
import UIKit

class PADPostersDataSource: NSObject, UICollectionViewDataSource {
    let CellIdentifier = "PADPosterCell"
    
    private lazy var array : Array<Dictionary<String, String>> = {
        let path = NSBundle.mainBundle().pathForResource("PADTiltViewControllerExample-Configuration", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        return dict!["posters"] as Array<Dictionary<String, String>>
    }()
    
    //MARK: - UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier, forIndexPath: indexPath) as UICollectionViewCell
        let dict = array[indexPath.row]
        
        let textLabel = cell.viewWithTag(100) as? UILabel
        let detailTextField = cell.viewWithTag(101) as? UITextField
        let imageView = cell.viewWithTag(102) as? UIImageView
        
        textLabel?.text = dict["text"]
        detailTextField?.text = dict["detailText"]
        imageView?.image = UIImage(named: dict["imageName"]!)
        imageView?.layer.borderColor = UIColor.whiteColor().CGColor
        
        return cell;
    }
}
