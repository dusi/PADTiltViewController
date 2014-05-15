//
//  PADTiltEnums.h
//  PADTiltViewController
//
//  Created by Pavel Dusatko on 5/3/14.
//  Copyright (c) 2014 Pavel Dusatko. All rights reserved.
//

/**
 *  @abstract The state of PADTiltViewController, PADTiltCollectionViewController or PADTiltTableViewController.
 */
typedef NS_ENUM(NSInteger, PADTiltViewControllerState) {
    PADTiltViewControllerStateInactive = -1,    // Inactive (default)
    PADTiltViewControllerStateInitializing,     // Initializing
    PADTiltViewControllerStateCalibrating,      // Calibrating
    PADTiltViewControllerStateActive            // Active
};
