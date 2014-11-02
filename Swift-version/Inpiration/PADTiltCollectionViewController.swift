//
//  PADTiltCollectionViewController.swift
//  Inpiration
//
//  Created by Alexander Hüllmandel on 10/31/14.
//  Copyright (c) 2014 Alexander Hüllmandel. All rights reserved.
//

import Foundation
import UIKit

/**
*  @abstract A collection view controller that adds device tilt capability to one directional collection views.
*/
class PADTiltCollectionViewController: UICollectionViewController {
 
//MARK: - NSObject - Creating, Copying, and Deallocating Objects
    deinit {
        pad_dealloc()
    }

    override init() {
        super.init()
        pad_init()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        pad_init()
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout!) {
        super.init(collectionViewLayout: layout)
        pad_init()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        pad_init()
    }

//MARK: - UIViewController - Responding to View Events
    override func viewDidDisappear(animated:Bool) {
        super.viewDidDisappear(animated)
        pad_stopReceivingTiltUpdates()
    }
    
//MARK: - UIViewController - Responding to View Rotation Events
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        super.willRotateToInterfaceOrientation(toInterfaceOrientation, duration: duration)
        pad_stopReceivingTiltUpdates()
    }
}