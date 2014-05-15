//
//  UIViewController+PADTiltAdditions.m
//  PADTiltViewController
//
//  Created by Pavel Dusatko on 5/4/14.
//  Copyright (c) 2014 Pavel Dusatko. All rights reserved.
//

#import "UIViewController+PADTiltAdditions.h"
#import <CoreMotion/CoreMotion.h>
#import "NSObject+AssociatedObjects.h"
#import "CMAttitude+PADTiltAdditions.h"
#import "PADTiltEnums.h"

@implementation UIViewController (PADTiltAdditions)

#pragma mark - Accessors

- (void)setPad_motionManager:(CMMotionManager *)pad_motionManager {
    [self associateValue:pad_motionManager withKey:@selector(pad_motionManager)];
}

- (CMMotionManager *)pad_motionManager {
    return [self associatedValueForKey:@selector(pad_motionManager)];
}

- (void)setPad_tiltDirection:(NSInteger)pad_tiltDirection {
    [self associateValue:@(pad_tiltDirection) withKey:@selector(pad_tiltDirection)];
}

- (NSInteger)pad_tiltDirection {
    return [[self associatedValueForKey:@selector(pad_tiltDirection)] integerValue];
}

- (void)setPad_state:(NSInteger)pad_state {
    [self associateValue:@(pad_state) withKey:@selector(pad_state)];
}

- (NSInteger)pad_state {
    return [[self associatedValueForKey:@selector(pad_state)] integerValue];
}

- (void)setPad_initialAttitude:(CMAttitude *)pad_initialAttitude {
    [self associateValue:pad_initialAttitude withKey:@selector(pad_initialAttitude)];
}

- (CMAttitude *)pad_initialAttitude {
    return [self associatedValueForKey:@selector(pad_initialAttitude)];
}

- (void)setPad_referenceAttitude:(CMAttitude *)pad_referenceAttitude {
    [self associateValue:pad_referenceAttitude withKey:@selector(pad_referenceAttitude)];
}

- (CMAttitude *)pad_referenceAttitude {
    return [self associatedValueForKey:@selector(pad_referenceAttitude)];
}

- (void)setPad_timer:(NSTimer *)pad_timer {
    [self associateValue:pad_timer withKey:@selector(pad_timer)];
}

- (NSTimer *)pad_timer {
    return [self associatedValueForKey:@selector(pad_timer)];
}

- (void)setPad_displayLink:(CADisplayLink *)pad_displayLink {
    [self associateValue:pad_displayLink withKey:@selector(pad_displayLink)];
}

- (CADisplayLink *)pad_displayLink {
    return [self associatedValueForKey:@selector(pad_displayLink)];
}

#pragma mark - Private

- (UIScrollView *)pad_scrollView {
    if ([self isKindOfClass:[UICollectionViewController class]]) {
        return [(UICollectionViewController *)self collectionView];
    }
    else if ([self isKindOfClass:[UITableViewController class]]) {
        return [(UITableViewController *)self tableView];
    }
    else if ([self isKindOfClass:[UIViewController class]]) {
        return ([self respondsToSelector:@selector(scrollView)] ? [self performSelector:@selector(scrollView)] : nil);
    }
    else {
        return nil;
    }
}

- (void)pad_enableTimer:(NSTimeInterval)timeInterval {
    [self pad_disableTimer];
    self.pad_timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(pad_calibrateDeviceMotion) userInfo:nil repeats:YES];
}

- (void)pad_disableTimer {
    [self.pad_timer invalidate];
    self.pad_timer = nil;
}

- (void)pad_enableDisplayLink {
    [self pad_disableDisplayLink];
    self.pad_displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(pad_tilt)];
    [self.pad_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)pad_disableDisplayLink {
    [self.pad_displayLink invalidate];
    self.pad_displayLink = nil;
}

#pragma mark - Target-Action

- (void)pad_dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self pad_disableTimer];
    [self pad_disableDisplayLink];
}

- (void)pad_init {
    self.pad_state = PADTiltViewControllerStateInactive;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pad_stopReceivingTiltUpdates)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

- (void)pad_startReceivingTiltUpdates {
    NSAssert(self.pad_motionManager, @"PADTiltViewController requires motion manager.");
    NSAssert(self.pad_scrollView, @"PADTiltViewController requires scroll view.");
    
    CMMotionManager *motionManager = self.pad_motionManager;
    
    if (motionManager.isDeviceMotionAvailable) {
        // Set the default update interval
        motionManager.deviceMotionUpdateInterval = 1.0/100.0;
        
        self.pad_state = PADTiltViewControllerStateInitializing;
        
        // Disable application's idle timer
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        
        CFTimeInterval startTime = CACurrentMediaTime();
        
        __weak typeof(self) weakSelf = self;
        
        [motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                           withHandler:^(CMDeviceMotion *motion, NSError *error) {
                                               __strong typeof(weakSelf) strongSelf = weakSelf;
                                               
                                               if (strongSelf.pad_state == PADTiltViewControllerStateInitializing) {
                                                   CFTimeInterval elapsedTime = CACurrentMediaTime() - startTime;
                                                   [strongSelf pad_initializeDeviceMotion:motion timeInterval:elapsedTime * 1.5];
                                               }
                                               else if (strongSelf.pad_state == PADTiltViewControllerStateCalibrating) {
                                                   [strongSelf pad_updateDeviceMotion:motion];
                                               }
                                               else if (strongSelf.pad_state == PADTiltViewControllerStateActive) {
                                                   [strongSelf pad_outputDeviceMotion:motion];
                                               }
                                           }];
    }
}

- (void)pad_stopReceivingTiltUpdates {
    CMMotionManager *motionManager = self.pad_motionManager;
    
    if (motionManager.isDeviceMotionActive) {
        [motionManager stopDeviceMotionUpdates];
        
        // Re-enable application's idle timer
        [UIApplication sharedApplication].idleTimerDisabled = NO;
        
        [self pad_disableTimer];
        [self pad_disableDisplayLink];
        
        self.pad_state = PADTiltViewControllerStateInactive;
        
        self.pad_initialAttitude = nil;
        self.pad_referenceAttitude = nil;
    }
}

#pragma mark - Device motion

- (void)pad_initializeDeviceMotion:(CMDeviceMotion *)motion timeInterval:(NSTimeInterval)timeInterval {
    self.pad_state = PADTiltViewControllerStateCalibrating;
    self.pad_initialAttitude = [motion.attitude copy];
    [self pad_enableTimer:timeInterval];
}

- (void)pad_updateDeviceMotion:(CMDeviceMotion *)motion {
    self.pad_referenceAttitude = [motion.attitude copy];
}

- (void)pad_outputDeviceMotion:(CMDeviceMotion *)motion {
    [motion.attitude multiplyByInverseOfAttitude:self.pad_referenceAttitude];
}

- (void)pad_calibrateDeviceMotion {
    if (!self.pad_referenceAttitude) {
        return;
    }
    
    CMAttitude *attitude = self.pad_initialAttitude;
    [attitude multiplyByInverseOfAttitude:self.pad_referenceAttitude];
    
    // Re-calibrate if necessary
    double minCalibrationOffset = 0.15;
    double tiltValue = [attitude pad_tiltValueWithTiltDirection:self.pad_tiltDirection interfaceOrientation:self.interfaceOrientation];
    
    if (fabs(tiltValue) > minCalibrationOffset) {
        self.pad_initialAttitude = [self.pad_referenceAttitude copy];
    }
    else {
        self.pad_state = PADTiltViewControllerStateActive;
        [self pad_disableTimer];
        [self pad_enableDisplayLink];
    }
}

#pragma mark - Tilting

- (void)pad_tiltVertically {
    UIScrollView *scrollView = self.pad_scrollView;
    
    CMAttitude *attitude = self.pad_motionManager.deviceMotion.attitude;
    [attitude multiplyByInverseOfAttitude:self.pad_referenceAttitude];
    
    CGPoint contentOffset = scrollView.contentOffset;
    CGFloat minimumYOffset = 0.0 - scrollView.contentInset.top;
    CGFloat maximumYOffset = scrollView.contentSize.height - CGRectGetHeight(scrollView.bounds) + scrollView.contentInset.bottom;
    CGFloat deltaYOffset = [attitude pad_scrollOffsetWithTiltDirection:self.pad_tiltDirection interfaceOrientation:self.interfaceOrientation];
    CGFloat contentYOffset = floor(contentOffset.y);
    
    NSInteger direction = [attitude pad_scrollDirectionWithTiltDirection:self.pad_tiltDirection interfaceOrientation:self.interfaceOrientation];
    
    if (direction == PADScrollDirectionDown) {
        if (contentYOffset + deltaYOffset > maximumYOffset) {
            deltaYOffset = maximumYOffset - contentYOffset;
        }
        if (contentYOffset + deltaYOffset > maximumYOffset) {
            return;
        }
        contentOffset.y += deltaYOffset;
    }
    else if (direction == PADScrollDirectionUp) {
        if (contentYOffset - deltaYOffset < minimumYOffset) {
            deltaYOffset = contentYOffset - minimumYOffset;
        }
        if (contentYOffset - deltaYOffset < minimumYOffset) {
            return;
        }
        contentOffset.y -= deltaYOffset;
    }
    
    [scrollView flashScrollIndicators];
    [scrollView setContentOffset:contentOffset];
}

- (void)pad_tiltHorizontally {
    UIScrollView *scrollView = self.pad_scrollView;
    
    CMAttitude *attitude = self.pad_motionManager.deviceMotion.attitude;
    [attitude multiplyByInverseOfAttitude:self.pad_referenceAttitude];
    
    CGPoint contentOffset = scrollView.contentOffset;
    CGFloat minimumXOffset = 0.0 - scrollView.contentInset.left;
    CGFloat maximumXOffset = scrollView.contentSize.width - CGRectGetWidth(scrollView.bounds) + scrollView.contentInset.right;
    CGFloat deltaXOffset = [attitude pad_scrollOffsetWithTiltDirection:self.pad_tiltDirection interfaceOrientation:self.interfaceOrientation];
    CGFloat contentXOffset = floor(contentOffset.x);
    
    NSInteger direction = [attitude pad_scrollDirectionWithTiltDirection:self.pad_tiltDirection interfaceOrientation:self.interfaceOrientation];
    
    if (direction == PADScrollDirectionRight) {
        if (contentXOffset + deltaXOffset > maximumXOffset) {
            deltaXOffset = maximumXOffset - contentXOffset;
        }
        if (contentXOffset + deltaXOffset > maximumXOffset) {
            return;
        }
        contentOffset.x += deltaXOffset;
    }
    else if (direction == PADScrollDirectionLeft) {
        if (contentXOffset - deltaXOffset < minimumXOffset) {
            deltaXOffset = contentXOffset - minimumXOffset;
        }
        if (contentXOffset - deltaXOffset < minimumXOffset) {
            return;
        }
        contentOffset.x -= deltaXOffset;
    }
    
    [scrollView flashScrollIndicators];
    [scrollView setContentOffset:contentOffset];
}

- (void)pad_tilt {
    if (self.pad_tiltDirection == PADTiltDirectionVertical) {
        [self pad_tiltVertically];
    }
    else if (self.pad_tiltDirection == PADTiltDirectionHorizontal) {
        [self pad_tiltHorizontally];
    }
}

@end
