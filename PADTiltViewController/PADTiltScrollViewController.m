//
//  PADTiltScrollViewController.m
//  PADTiltViewController
//
//  Created by Pavel Dusatko on 4/30/14.
//  Copyright (c) 2014 Pavel Dusatko. All rights reserved.
//

#import "PADTiltScrollViewController.h"
#import "UIViewController+PADTiltAdditions.h"

@implementation PADTiltScrollViewController

#pragma mark - NSObject - Creating, Copying, and Deallocating Objects

- (void)dealloc {
    [self pad_dealloc];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self pad_init];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self pad_init];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self pad_init];
    }
    return self;
}

#pragma mark - UIViewController - Responding to View Events

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self pad_stopReceivingTiltUpdates];
}

#pragma mark - UIViewController - Responding to View Rotation Events

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self pad_stopReceivingTiltUpdates];
}

@end
