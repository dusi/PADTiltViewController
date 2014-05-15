//
//  PADTiltTableViewControllerExample.m
//  PADTiltViewControllerExample
//
//  Created by Pavel Dusatko on 5/3/14.
//  Copyright (c) 2014 Pavel Dusatko. All rights reserved.
//

#import "PADTiltTableViewControllerExample.h"
#import <PADTiltViewController/UIViewController+PADTiltAdditions.h>
#import "PADAppDelegate.h"

@interface PADTiltTableViewControllerExample () <UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;

@end

@implementation PADTiltTableViewControllerExample

#pragma mark - NSObject - Creating, Copying, and Deallocating Objects

- (void)dealloc {
    @try {
        [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(pad_state)) context:NULL];
    }
    @catch (NSException *exception) {}
}

#pragma mark - UIViewController - Managing the View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pad_motionManager = [(PADAppDelegate *)[[UIApplication sharedApplication] delegate] motionManager];
    
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(pad_state)) options:NSKeyValueObservingOptionNew context:NULL];
    
    [self enableLongPressGestureRecognizer];
}

#pragma mark - Gesture recognizers

- (void)removeGestureRecognizers {
    for (UIGestureRecognizer *gestureRecognizer in self.view.gestureRecognizers) {
        if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] || [gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] || [gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
            [self.view removeGestureRecognizer:gestureRecognizer];
        }
    }
}

- (void)enableLongPressGestureRecognizer {
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(startReceivingTiltUpdates:)];
    [self.view addGestureRecognizer:longPressGestureRecognizer];
}

- (void)enableLongPressTapAndSwipeGestureRecognizer {
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(stopReceivingTiltUpdates:)];
    [self.view addGestureRecognizer:longPressGestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopReceivingTiltUpdates:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(stopReceivingTiltUpdates:)];
    swipeGestureRecognizer.delegate = self;
    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeGestureRecognizer];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - Target-Action

- (void)startReceivingTiltUpdates {
    [self pad_startReceivingTiltUpdates];
    
    [self removeGestureRecognizers];
    [self enableLongPressTapAndSwipeGestureRecognizer];
}

- (void)stopReceivingTiltUpdates {
    [self pad_stopReceivingTiltUpdates];
    
    [self removeGestureRecognizers];
    [self enableLongPressGestureRecognizer];
}

- (void)startReceivingTiltUpdates:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self startReceivingTiltUpdates];
    }
}

- (void)stopReceivingTiltUpdates:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan || gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self stopReceivingTiltUpdates];
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(pad_state))]) {
        [self updateUserInterfaceForState:[object pad_state]];
    }
}

#pragma mark - Private

- (void)updateUserInterfaceForState:(NSInteger)state {
    if (state == PADTiltViewControllerStateInactive) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        
        self.navigationController.navigationBar.barTintColor = nil;
        self.titleLabel.text = NSLocalizedString(@"Sensors Off", nil);
        self.titleLabel.textColor = [UIColor blackColor];
        self.subtitleLabel.text = NSLocalizedString(@"Long press the content to enable sensors", nil);
        self.subtitleLabel.textColor = [UIColor blackColor];
        
        [UIView animateWithDuration:0.35 animations:^{
            self.tabBarController.tabBar.alpha = 1.0;
        }];
    }
    else if (state == PADTiltViewControllerStateInitializing || state == PADTiltViewControllerStateCalibrating) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
        self.titleLabel.text = NSLocalizedString(@"Calibrating Sensors", nil);
        self.titleLabel.textColor = [UIColor whiteColor];
        self.subtitleLabel.text = NSLocalizedString(@"Hold still for a moment", nil);
        self.subtitleLabel.textColor = [UIColor whiteColor];
        
        [UIView animateWithDuration:0.35 animations:^{
            self.tabBarController.tabBar.alpha = 0.0;
        }];
    }
    else if (state == PADTiltViewControllerStateActive) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
        self.titleLabel.text = NSLocalizedString(@"Sensors On", nil);
        self.titleLabel.textColor = [UIColor whiteColor];
        self.subtitleLabel.text = NSLocalizedString(@"Tap or swipe the content to disable sensors", nil);
        self.subtitleLabel.textColor = [UIColor whiteColor];
    }
}

@end
