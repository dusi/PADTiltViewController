//
//  PADTiltTableViewControllerExample.swift
//  Inpiration
//
//  Created by Alexander Hüllmandel on 10/31/14.
//  Copyright (c) 2014 Alexander Hüllmandel. All rights reserved.
//

import Foundation
import UIKit

class PADTiltTableViewControllerExample: PADTiltTableViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    //MARK: - NSObject - Creating, Copying, and Deallocating Objects
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kPadStateChanged, object: nil)
    }
    
    //MARK: - UIViewController - Managing the View
    override func viewDidLoad() {
        super.viewDidLoad()
        pad_motionManager = (UIApplication.sharedApplication().delegate as? AppDelegate)?.motionManager
        
        NSNotificationCenter.defaultCenter().addObserverForName(kPadStateChanged, object: nil, queue: NSOperationQueue.mainQueue()) { notification in
            let userInfo = notification.userInfo as Dictionary<String,Int!>
            if let padStateValue = userInfo[kNewPadState] {
                let newState = PADTiltViewControllerState(rawValue:padStateValue)
                self.updateUserInterfaceForState(newState!)
            }
        }
        
        enableLongPressGestureRecognizer()
    }
    
    //MARK: - Gesture recognizers
    func removeGestureRecognizers() {
        for gestureRecognizer in self.view.gestureRecognizers as [UIGestureRecognizer] {
            if (gestureRecognizer is UILongPressGestureRecognizer || gestureRecognizer is UITapGestureRecognizer
                || gestureRecognizer is UISwipeGestureRecognizer) {
                    self.view.removeGestureRecognizer(gestureRecognizer)
            }
        }
    }
    
    func enableLongPressGestureRecognizer() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("startReceivingTiltUpdates:"))
        self.view.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    func enableLongPressTapAndSwipeGestureRecognizer() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("stopReceivingTiltUpdates:"))
        self.view.addGestureRecognizer(longPressGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("stopReceivingTiltUpdates:"))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("stopReceivingTiltUpdates:"))
        swipeGestureRecognizer.delegate = self
        swipeGestureRecognizer.direction = .Up | .Down
        self.view.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    //MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //MARK: - Target-Action
    
    func startReceivingTiltUpdates() {
        pad_startReceivingTiltUpdates()
        
        removeGestureRecognizers()
        enableLongPressTapAndSwipeGestureRecognizer()
    }
    
    func stopReceivingTiltUpdates() {
        pad_stopReceivingTiltUpdates()
        
        removeGestureRecognizers()
        enableLongPressGestureRecognizer()
    }
    
    func startReceivingTiltUpdates(gestureRecognizer: UIGestureRecognizer) {
        if (gestureRecognizer.state == .Began) {
            startReceivingTiltUpdates()
        }
    }
    
    func stopReceivingTiltUpdates(gestureRecognizer: UIGestureRecognizer) {
        if (gestureRecognizer.state == .Began || gestureRecognizer.state == .Ended) {
            stopReceivingTiltUpdates()
        }
    }
    
    //MARK: - Private
    
    func updateUserInterfaceForState(state: PADTiltViewControllerState) {
        if (state == .Inactive) {
            UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: false)
            
            if let navigationController = navigationController {
                navigationController.navigationBar.barTintColor = nil
            }
            titleLabel.text = NSLocalizedString("Sensors Off", comment:"")
            titleLabel.textColor = UIColor.blackColor()
            subtitleLabel.text = NSLocalizedString("Long press the content to enable sensors", comment:"")
            subtitleLabel.textColor = UIColor.blackColor()
            
            UIView.animateWithDuration(0.35) {
                self.tabBarController!.tabBar.alpha = 1.0
            }
        }
        else if (state == .Initializing || state == .Calibrating) {
            UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
            
            if let navigationController = navigationController {
                navigationController.navigationBar.barTintColor = UIColor.lightGrayColor()
            }
            titleLabel.text = NSLocalizedString("Calibrating Sensors", comment:"")
            titleLabel.textColor = UIColor.whiteColor()
            subtitleLabel.text = NSLocalizedString("Hold still for a moment", comment:"")
            subtitleLabel.textColor = UIColor.whiteColor()
            
            UIView.animateWithDuration(0.35) {
                self.tabBarController!.tabBar.alpha = 0.0
            }
        }
        else if (state == .Active) {
            UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
            
            if let navigationController = navigationController {
                navigationController.navigationBar.barTintColor = UIColor.lightGrayColor()
            }
            titleLabel.text = NSLocalizedString("Sensors On", comment:"")
            titleLabel.textColor = UIColor.whiteColor()
            subtitleLabel.text = NSLocalizedString("Tap or swipe the content to disable sensors", comment:"")
            subtitleLabel.textColor = UIColor.whiteColor()
        }
    }
}