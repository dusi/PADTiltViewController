//
//  CMAttitude+PADTiltAdditions.m
//  PADTiltViewController
//
//  Created by Pavel Dusatko on 5/4/14.
//  Copyright (c) 2014 Pavel Dusatko. All rights reserved.
//

#import "CMAttitude+PADTiltAdditions.h"
#import "PADTiltEnums.h"

@implementation CMAttitude (PADTiltAdditions)

#pragma mark - Tilt

- (double)pad_tiltValueWithTiltDirection:(PADTiltDirection)tiltDirection interfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (tiltDirection == PADTiltDirectionVertical) {
        return (UIInterfaceOrientationIsPortrait(interfaceOrientation) ? self.pitch : self.roll);
    }
    else if (tiltDirection == PADTiltDirectionHorizontal) {
        return (UIInterfaceOrientationIsPortrait(interfaceOrientation) ? self.roll : self.pitch);
    }
    else {
        return 0.0;
    }
}

#pragma mark - Scrolling

- (CGFloat)pad_scrollOffsetWithTiltDirection:(PADTiltDirection)tiltDirection interfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    double tiltValue = [self pad_tiltValueWithTiltDirection:tiltDirection interfaceOrientation:interfaceOrientation];
    double delta = fabs(tiltValue);
    
    if (delta >= 0.04 && delta < 0.08) {
        return PADScrollOffsetXSmall;
    }
    else if (delta >= 0.08 && delta < 0.12) {
        return PADScrollOffsetSmall;
    }
    else if (delta >= 0.12 && delta < 0.16) {
        return PADScrollOffsetMedium;
    }
    else if (delta >= 0.16 && delta < 0.2) {
        return PADScrollOffsetLarge;
    }
    else if (delta >= 0.2 && delta < 0.24) {
        return PADScrollOffsetXLarge;
    }
    else if (delta >= 0.24) {
        return PADScrollOffsetFTL;
    }
    else {
        return PADScrollOffsetZero;
    }
}

- (NSInteger)pad_scrollDirectionWithTiltDirection:(PADTiltDirection)tiltDirection interfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    double tiltValue = [self pad_tiltValueWithTiltDirection:tiltDirection interfaceOrientation:interfaceOrientation];
    
    if (tiltDirection == PADTiltDirectionVertical) {
        return (tiltValue > 0 ? PADScrollDirectionUp : PADScrollDirectionDown);
    }
    else if (tiltDirection == PADTiltDirectionHorizontal) {
        return (tiltValue > 0 ? PADScrollDirectionLeft : PADScrollDirectionRight);
    }
    else {
        return -1;
    }
}

@end
