//
//  PADTiltScrollViewController.h
//  PADTiltViewController
//
//  Created by Pavel Dusatko on 4/30/14.
//  Copyright (c) 2014 Pavel Dusatko. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @abstract A view controller that adds device tilt capability to one directional scroll views.
 */
@interface PADTiltScrollViewController : UIViewController

/**
 *  The scroll view outlet.
 */
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@end
