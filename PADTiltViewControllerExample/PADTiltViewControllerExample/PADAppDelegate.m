//
//  PADAppDelegate.m
//  PADTiltViewControllerExample
//
//  Created by Pavel Dusatko on 4/30/14.
//  Copyright (c) 2014 Pavel Dusatko. All rights reserved.
//

#import "PADAppDelegate.h"
#import <CoreMotion/CoreMotion.h>

@interface PADAppDelegate ()

@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation PADAppDelegate

#pragma mark - UIApplicationDelegate - Monitoring App State Changes

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

#pragma mark - Accessors

- (CMMotionManager *)motionManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _motionManager = [[CMMotionManager alloc] init];
    });
    return _motionManager;
}

@end
