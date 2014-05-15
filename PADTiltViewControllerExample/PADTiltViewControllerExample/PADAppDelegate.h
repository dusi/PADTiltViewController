//
//  PADAppDelegate.h
//  PADTiltViewControllerExample
//
//  Created by Pavel Dusatko on 4/30/14.
//  Copyright (c) 2014 Pavel Dusatko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMMotionManager;

@interface PADAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong, readonly) CMMotionManager *motionManager;

@end
