//
//  PADFeedDataSource.m
//  PADTiltViewControllerExample
//
//  Created by Pavel Dusatko on 4/30/14.
//  Copyright (c) 2014 Pavel Dusatko. All rights reserved.
//

#import "PADFeedDataSource.h"

static NSString *CellIdentifier = @"PADFeedCell";

@interface PADFeedDataSource ()

@property (nonatomic, strong) NSArray *array;

@end

@implementation PADFeedDataSource

#pragma mark - Accessors

- (NSArray *)array {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"PADTiltViewControllerExample-Configuration" ofType:@"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        _array = dict[@"feed"];
    });
    return _array;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PADFeedCell" forIndexPath:indexPath];
    NSDictionary *dict = self.array[indexPath.row];
    
    UILabel *textLabel = (UILabel *)[cell viewWithTag:100];
    UITextField *detailTextField = (UITextField *)[cell viewWithTag:101];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:102];
    
    textLabel.text = dict[@"text"];
    detailTextField.text = dict[@"detailText"];
    imageView.image = [UIImage imageNamed:dict[@"imageName"]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.array[indexPath.row];
    NSString *heightKeyPath = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? @"height.phone" : @"height.pad";
    return [[dict valueForKeyPath:heightKeyPath] floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
