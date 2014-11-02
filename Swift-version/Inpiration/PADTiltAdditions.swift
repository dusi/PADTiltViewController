//
//  PADTiltAdditions.swift
//  Inpiration
//
//  Created by Alexander Hüllmandel on 10/30/14.
//  Copyright (c) 2014 Alexander Hüllmandel. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion

//MARK: Enums

/**
*  @abstract The direction of tilt.
*/
public enum PADTiltDirection : Int {
    case Vertical   // Vertical tilt (default)
    case Horizontal // Horizontal tilt
}

/**
*  @abstract The direction of scrolling.
*/
public enum PADScrollDirection {
    case Up       // Up
    case Down     // Down
    case Left     // Left
    case Right    // Right
    case Invalid // Invalid tilt
}

/**
*  @abstract The amount of scroll offset per tick.
*/
public enum PADScrollOffset: Int {
    case Zero     = 0    // Still
    case XSmall   = 2    // Extra slow scrolling
    case Small    = 4    // Slow scrolling
    case Medium   = 8    // Medium scrolling
    case Large    = 16   // Fast scrolling
    case XLarge   = 32   // Extra fast scrolling
    case FTL      = 128   // Ultra fast (Faster Than Light) scrolling
}

/**
*  @abstract The state of PADTiltViewController, PADTiltCollectionViewController or PADTiltTableViewController.
*/
public enum PADTiltViewControllerState : Int {
    case Inactive = -1    // Inactive (default)
    case Initializing     // Initializing
    case Calibrating      // Calibrating
    case Active           // Active
}


//MARK: - Extensions
/**
*  @abstract A category of CMAttitude with the tilt extensions.
*/
//MARK: - Extension CMAttitude
public extension CMAttitude {
    /**
    *  @abstract The tilt value of the attitude for a specific tilt direction and interface orientation.
    *  @param tiltDirection        PADTiltDirection enum value.
    *  @param interfaceOrientation Interface orientation of the view controller.
    *  @return The value of tilt based on the tilt direction and interface orientation.
    */
    public func pad_tiltValueWithTiltDirection(tiltDirection:PADTiltDirection, interfaceOrientation:UIInterfaceOrientation) -> Double {
        switch tiltDirection {
        case .Horizontal :
            return (UIInterfaceOrientationIsPortrait(interfaceOrientation) ? roll : pitch)
        case .Vertical :
            return (UIInterfaceOrientationIsPortrait(interfaceOrientation) ? pitch: roll)
        default :
            return 0.0
        }
    }
    
    /**
    *  @abstract The scroll offset of the attitude for a specific tilt direction and interface orientation.
    *  @param tiltDirection        PADTiltDirection enum value.
    *  @param interfaceOrientation Interface orientation of the view controller.
    *  @return The PADScrollOffset enum value.
    */
    public func pad_scrollOffsetWithTiltDirection(tiltDirection:PADTiltDirection, interfaceOrientation:UIInterfaceOrientation) -> PADScrollOffset {
        let tiltValue = pad_tiltValueWithTiltDirection(tiltDirection, interfaceOrientation: interfaceOrientation)
        let delta = fabs(tiltValue)
        
        switch delta {
        case 0.04 ..< 0.08:
            return .XSmall
        case 0.08 ..< 0.12:
            return .Small
        case 0.12 ..< 0.16:
            return .Medium
        case 0.16 ..< 0.2:
            return .Large
        case 0.2 ..< 0.24:
            return .XLarge
        case 0.24 ..< 1.0:
            return .FTL
        default :
            return .Zero
        }
    }
    
    /**
    *  @abstract The scroll direction of the attitude for a specific tilt direction and interface orientation.
    *  @param tiltDirection        PADTiltDirection enum value.
    *  @param interfaceOrientation Interface orientation of the view controller.
    *  @return The PADScrollDirection enum value.
    */
    public func pad_scrollDirectionWithTiltDirection(tiltDirection:PADTiltDirection, interfaceOrientation:UIInterfaceOrientation) -> PADScrollDirection {
        let tiltValue = pad_tiltValueWithTiltDirection(tiltDirection, interfaceOrientation:interfaceOrientation)
        
        switch tiltDirection {
        case .Horizontal :
            return (tiltValue > Double(0.0)) ? .Left : .Right
        case .Vertical :
            return (tiltValue > Double(0.0)) ? .Up : .Down
        default :
            return .Invalid
        }
    }
}

//MARK: - Extension NSObject
extension NSObject {
    /**
    *  @abstract The associated value setter.
    *  @param value The associated object.
    *  @param key   The associated key.
    */
    public func associateValue(value:AnyObject, withKey key:UnsafePointer<Void>) {
        objc_setAssociatedObject(self, key, value, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
    }
    
    /**
    *  @abstract The associated value getter.
    *  @param key The associated key.
    *  @return The associated object.
    */
    public func associatedValueForKey(key: UnsafePointer<Void>) -> AnyObject {
        return objc_getAssociatedObject(self, key)
    }
}


//MARK: - Extension UIViewController
/**
*  A UIViewController extension that adds tilt specific properties using associated objects.
*/
private var pad_motionManagerKey:       UInt8 = 0
private var pad_tiltDirectionKey:       UInt8 = 1
private var pad_stateKey:               UInt8 = 2
private var pad_initialAttitudeKey:     UInt8 = 3
private var pad_referenceAttitudeKey:   UInt8 = 4
private var pad_timerKey:               UInt8 = 5
private var pad_displayLinkKey:         UInt8 = 6

let kPadStateChanged = "PadStateChanged"
let kNewPadState = "newState"

public extension UIViewController {
    /**
    *  @abstract The motion manager.
    */
    var pad_motionManager: CMMotionManager? {
        get {
            return objc_getAssociatedObject(self, &pad_motionManagerKey) as? CMMotionManager
        }
        set(newValue) {
            objc_setAssociatedObject(self, &pad_motionManagerKey, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
        }
    }
    
    /**
    *  @abstract The PADTiltDirection enum value.
    */
    var pad_tiltDirection: PADTiltDirection? {
        get {
            if let value = objc_getAssociatedObject(self, &pad_tiltDirectionKey) as? Int {
                return PADTiltDirection(rawValue:value)
            }
            else {
                return .Vertical
            }
        }
        set(newValue) {
            objc_setAssociatedObject(self, &pad_tiltDirectionKey, newValue?.rawValue, UInt(OBJC_ASSOCIATION_ASSIGN))
        }
    }

    
    /**
    *  @abstract The PADTiltViewControllerState enum value.
    */
    var pad_state: PADTiltViewControllerState? {
        get {
            return PADTiltViewControllerState(rawValue: objc_getAssociatedObject(self, &pad_stateKey) as Int)
        }
        set(newValue) {
            objc_setAssociatedObject(self, &pad_stateKey, newValue?.rawValue, UInt(OBJC_ASSOCIATION_ASSIGN))
            NSNotificationCenter.defaultCenter().postNotificationName(kPadStateChanged, object: nil,
                userInfo: [kNewPadState: newValue!.rawValue])
        }
    }
    
    /**
    *  @abstract The initial attitude used for calibration purposes.
    */
    var pad_initialAttitude: CMAttitude? {
        get {
            return objc_getAssociatedObject(self, &pad_initialAttitudeKey) as? CMAttitude
        }
        set(newValue) {
            objc_setAssociatedObject(self, &pad_initialAttitudeKey, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
        }
    }
    
    /**
    *  @abstract The reference attitude used for tilt calculations.
    */
    var pad_referenceAttitude: CMAttitude? {
        get {
            return objc_getAssociatedObject(self, &pad_referenceAttitudeKey) as? CMAttitude
        }
        set(newValue) {
            objc_setAssociatedObject(self, &pad_referenceAttitudeKey, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
        }
    }
    
    /**
    *  @abstract The calibration timer.
    */
    var pad_timer: NSTimer? {
        get {
            return objc_getAssociatedObject(self, &pad_timerKey) as? NSTimer
        }
        set(newValue) {
            objc_setAssociatedObject(self, &pad_timerKey, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
        }
    }
    
    /**
    *  @abstract The display link used for tilt scrolling.
    */
    var pad_displayLink: CADisplayLink? {
        get {
            return objc_getAssociatedObject(self, &pad_displayLinkKey) as? CADisplayLink
        }
        set(newValue) {
            objc_setAssociatedObject(self, &pad_displayLinkKey, newValue, UInt(OBJC_ASSOCIATION_RETAIN))
        }
    }
    
//MARK: - Public API
    /**
    *  @abstract The dealloc action.
    */
    public func pad_dealloc() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        pad_disableTimer()
        pad_disableDisplayLink()
    }
    
    /**
    *  @abstract The init action.
    */
    public func pad_init() {
        let pad_state = PADTiltViewControllerState.Active
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("pad_stopReceivingTiltUpdates"), name: UIApplicationDidEnterBackgroundNotification, object: nil)
    }
    
    /**
    *  @abstract The action that starts receiving tilt updates.
    */
    public func pad_startReceivingTiltUpdates() {
        assert (pad_motionManager != nil, "PADTiltViewController requires motion manager.")
        assert (pad_scrollView() != nil, "PADTiltViewController requires scroll view.")

        if let motionManager = pad_motionManager {
            if (motionManager.deviceMotionAvailable) {
                // Set the default update interval
                motionManager.deviceMotionUpdateInterval = 1.0/100.0
                
                pad_state = PADTiltViewControllerState.Initializing
                
                // Disable application's idle timer
                UIApplication.sharedApplication().idleTimerDisabled = true
                
                let startTime = CACurrentMediaTime()

                motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) {
                    [weak self] (motion: CMDeviceMotion!, error: NSError!) in
                    if let state = self!.pad_state {
                        switch state {
                        case .Initializing:
                            let elapsedTime = CACurrentMediaTime() - startTime
                            self!.pad_initializeDeviceMotion(motion, timeInterval:elapsedTime * 1.5)
                        case .Calibrating:
                            self!.pad_updateDeviceMotion(motion)
                        case .Active:
                            self!.pad_outputDeviceMotion(motion)
                        default:
                            println("Inactive State.")
                        }
                    }
                }
            }
        }
    }
    
    /**
    *  @abstract The action that stops receiving tilt updates.
    */
    public func pad_stopReceivingTiltUpdates() {
        if let motionManager = pad_motionManager {
            if (motionManager.deviceMotionActive) {
                motionManager.stopDeviceMotionUpdates()
                
                // Re-enable application's idle timer
                UIApplication.sharedApplication().idleTimerDisabled = false
                
                pad_disableTimer()
                pad_disableDisplayLink()
                
                pad_state = .Inactive
                
                pad_initialAttitude = nil
                pad_referenceAttitude = nil
            }
        }
    }
    
//MARK: - Private API
    private func pad_scrollView() -> UIScrollView? {
        if (self is UICollectionViewController) {
            return (self as UICollectionViewController).collectionView
        }
        else if (self.isKindOfClass(UITableViewController)) {
            return (self as UITableViewController).tableView
        }
            
        else if (self.isKindOfClass(UIViewController)) {
            // todo: scrollView should be a protocol property
            let scrollView = (self as PADTiltScrollViewController).scrollView
            return (self as PADTiltScrollViewController).scrollView
        }
        else {
            return nil
        }
    }
    
    private func pad_enableTimer(timeInterval: NSTimeInterval) {
        pad_disableTimer()
        pad_timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: Selector("pad_calibrateDeviceMotion"), userInfo: nil, repeats: true)
    }
    
    private func pad_disableTimer() {
        pad_timer?.invalidate()
        pad_timer = nil
    }
    
    private func pad_enableDisplayLink() {
        pad_disableDisplayLink()
        pad_displayLink = CADisplayLink.init(target: self, selector: Selector("pad_tilt"))
        pad_displayLink!.addToRunLoop(NSRunLoop.mainRunLoop(), forMode:NSDefaultRunLoopMode)
    }
    
    private func pad_disableDisplayLink() {
        pad_displayLink?.invalidate()
        pad_displayLink = nil
    }
    
    //MARK: - Device motion
    
    private func pad_initializeDeviceMotion(motion:CMDeviceMotion, timeInterval:NSTimeInterval) {
        pad_state = .Calibrating
        pad_initialAttitude = motion.attitude
        pad_enableTimer(timeInterval)
    }
    
    private func pad_updateDeviceMotion(motion:CMDeviceMotion) {
        pad_referenceAttitude = motion.attitude
        println("motion attitude\(motion.attitude)")
        println("ref attitude\(pad_referenceAttitude)")
    }
    
    private func pad_outputDeviceMotion(motion: CMDeviceMotion) {
        motion.attitude.multiplyByInverseOfAttitude(pad_referenceAttitude)
    }
    
    public func pad_calibrateDeviceMotion() {
        if pad_referenceAttitude != nil {
            let referenceAttitude = pad_referenceAttitude!
            if let attitude = pad_initialAttitude {
                attitude.multiplyByInverseOfAttitude(pad_referenceAttitude)
                
                // Re-calibrate if necessary
                let minCalibrationOffset = 0.15
            
                let tiltValue  = attitude.pad_tiltValueWithTiltDirection(pad_tiltDirection!, interfaceOrientation: self.interfaceOrientation)
                
                if (fabs(tiltValue) > minCalibrationOffset) {
                    pad_initialAttitude = pad_referenceAttitude
                }
                else {
                    pad_state = .Active
                    pad_disableTimer()
                    pad_enableDisplayLink()
                }
            }
        }
    }
    
    //MARK: - Tilting
    
    private func pad_tiltVertically() {
        if let scrollView = self.pad_scrollView() {
            if let attitude =  pad_motionManager?.deviceMotion.attitude {
                attitude.multiplyByInverseOfAttitude(pad_referenceAttitude)
                
                var contentOffset = scrollView.contentOffset
                let minimumYOffset = 0.0 - scrollView.contentInset.top
                let maximumYOffset = scrollView.contentSize.height - CGRectGetHeight(scrollView.bounds) + scrollView.contentInset.bottom
                var deltaYOffset = CGFloat(attitude.pad_scrollOffsetWithTiltDirection(pad_tiltDirection!, interfaceOrientation: self.interfaceOrientation).rawValue)

                let contentYOffset = floor(contentOffset.y)
                
                let direction  = attitude.pad_scrollDirectionWithTiltDirection(pad_tiltDirection!, interfaceOrientation: self.interfaceOrientation)
                
                if (direction == .Down) {
                    if(contentYOffset + deltaYOffset > maximumYOffset) {
                        deltaYOffset = maximumYOffset - contentYOffset
                    }
                    if(contentYOffset + deltaYOffset > maximumYOffset) {
                        return
                    }
                    contentOffset.y += deltaYOffset
                } else if (direction == .Up) {
                    if (contentYOffset - deltaYOffset < minimumYOffset) {
                        deltaYOffset = contentYOffset - minimumYOffset
                    }
                    if (contentYOffset - deltaYOffset < minimumYOffset) {
                        return
                    }
                    contentOffset.y -= deltaYOffset
                }
                
                scrollView.flashScrollIndicators()
                scrollView.setContentOffset(contentOffset, animated: false)
            }
        }
    }

    private func pad_tiltHorizontally() {
        if let scrollView = self.pad_scrollView() {
            if let attitude =  pad_motionManager?.deviceMotion.attitude {
                attitude.multiplyByInverseOfAttitude(pad_referenceAttitude)
                
                var contentOffset = scrollView.contentOffset
                let minimumXOffset = 0.0 - scrollView.contentInset.left
                let maximumXOffset = scrollView.contentSize.width - CGRectGetHeight(scrollView.bounds) + scrollView.contentInset.right
                var deltaXOffset = CGFloat(attitude.pad_scrollOffsetWithTiltDirection(pad_tiltDirection!, interfaceOrientation: self.interfaceOrientation).rawValue)
                let contentXOffset = floor(contentOffset.x)
                
                let direction  = attitude.pad_scrollDirectionWithTiltDirection(pad_tiltDirection!, interfaceOrientation: self.interfaceOrientation)
                
                if (direction == .Right) {
                    if(contentXOffset + deltaXOffset > maximumXOffset) {
                        deltaXOffset = maximumXOffset - contentXOffset
                    }
                    if(contentXOffset + deltaXOffset > maximumXOffset) {
                        return
                    }
                    contentOffset.x += deltaXOffset
                } else if (direction == .Left) {
                    if (contentXOffset - deltaXOffset < minimumXOffset) {
                        deltaXOffset = contentXOffset - minimumXOffset
                    }
                    if (contentXOffset - deltaXOffset < minimumXOffset) {
                        return
                    }
                    contentOffset.x -= deltaXOffset
                }
                
                scrollView.flashScrollIndicators()
                scrollView.setContentOffset(contentOffset, animated: false)
            }
        }
    }
    
    /**
    *  @abstract The init action.
    */
    public func pad_tilt() {
        if (pad_tiltDirection == .Vertical) {
            pad_tiltVertically()
        }
        else if (pad_tiltDirection == .Horizontal) {
            pad_tiltHorizontally()
        }
    }
}