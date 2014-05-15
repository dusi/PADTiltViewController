//
//  UIViewController+PADTiltAdditions.h
//  PADTiltViewController
//
//  Created by Pavel Dusatko on 5/4/14.
//  Copyright (c) 2014 Pavel Dusatko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMAttitude;
@class CMMotionManager;

/**
 *  A UIViewController extension that adds tilt specific properties using associated objects.
 */
@interface UIViewController (PADTiltAdditions)

/**
 *  @abstract The motion manager.
 */
@property (nonatomic, strong) CMMotionManager *pad_motionManager;

/**
 *  @abstract The PADTiltDirection enum value.
 */
@property (nonatomic, assign) NSInteger pad_tiltDirection;

/**
 *  @abstract The PADTiltViewControllerState enum value.
 */
@property (nonatomic, assign) NSInteger pad_state;

/**
 *  @abstract The initial attitude used for calibration purposes.
 */
@property (nonatomic, strong) CMAttitude *pad_initialAttitude;

/**
 *  @abstract The reference attitude used for tilt calculations.
 */
@property (nonatomic, strong) CMAttitude *pad_referenceAttitude;

/**
 *  @abstract The calibration timer.
 */
@property (nonatomic, strong) NSTimer *pad_timer;

/**
 *  @abstract The display link used for tilt scrolling.
 */
@property (nonatomic, strong) CADisplayLink *pad_displayLink;

/**
 *  @abstract The init action.
 */
- (void)pad_init;

/**
 *  @abstract The dealloc action.
 */
- (void)pad_dealloc;

/**
 *  @abstract The action that starts receiving tilt updates.
 */
- (void)pad_startReceivingTiltUpdates;

/**
 *  @abstract The action that stops receiving tilt updates.
 */
- (void)pad_stopReceivingTiltUpdates;

@end
