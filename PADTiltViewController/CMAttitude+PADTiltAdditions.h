//
//  CMAttitude+PADTiltAdditions.h
//  PADTiltViewController
//
//  Created by Pavel Dusatko on 5/4/14.
//  Copyright (c) 2014 Pavel Dusatko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

/**
 *  @abstract The direction of tilt.
 */
typedef NS_ENUM(NSInteger, PADTiltDirection) {
    PADTiltDirectionVertical,   // Vertical tilt (default)
    PADTiltDirectionHorizontal  // Horizontal tilt
};

/**
 *  @abstract The direction of scrolling.
 */
typedef NS_ENUM(NSInteger, PADScrollDirection) {
    PADScrollDirectionUp,       // Up
    PADScrollDirectionDown,     // Down
    PADScrollDirectionLeft,     // Left
    PADScrollDirectionRight,    // Right
};

/**
 *  @abstract The amount of scroll offset per tick.
 */
typedef NS_ENUM(NSInteger, PADScrollOffset) {
    PADScrollOffsetZero     = 0,    // Still
    PADScrollOffsetXSmall   = 2,    // Extra slow scrolling
    PADScrollOffsetSmall    = 4,    // Slow scrolling
    PADScrollOffsetMedium   = 8,    // Medium scrolling
    PADScrollOffsetLarge    = 16,   // Fast scrolling
    PADScrollOffsetXLarge   = 32,   // Extra fast scrolling
    PADScrollOffsetFTL      = 128   // Ultra fast (Faster Than Light) scrolling
};

/**
 *  @abstract A category of CMAttitude with the tilt extensions.
 */
@interface CMAttitude (PADTiltAdditions)

/**
*  @abstract The tilt value of the attitude for a specific tilt direction and interface orientation.
*  @param tiltDirection        PADTiltDirection enum value.
*  @param interfaceOrientation Interface orientation of the view controller.
*  @return The value of tilt based on the tilt direction and interface orientation.
*/
- (double)pad_tiltValueWithTiltDirection:(PADTiltDirection)tiltDirection interfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

/**
 *  @abstract The scroll offset of the attitude for a specific tilt direction and interface orientation.
 *  @param tiltDirection        PADTiltDirection enum value.
 *  @param interfaceOrientation Interface orientation of the view controller.
 *  @return The PADScrollOffset enum value.
 */
- (CGFloat)pad_scrollOffsetWithTiltDirection:(PADTiltDirection)tiltDirection interfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

/**
 *  @abstract The scroll direction of the attitude for a specific tilt direction and interface orientation.
 *  @param tiltDirection        PADTiltDirection enum value.
 *  @param interfaceOrientation Interface orientation of the view controller.
 *  @return The PADScrollDirection enum value.
 */
- (NSInteger)pad_scrollDirectionWithTiltDirection:(PADTiltDirection)tiltDirection interfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end
