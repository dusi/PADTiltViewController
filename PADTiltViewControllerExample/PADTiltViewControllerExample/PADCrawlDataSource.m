//
//  PADCrawlDataSource.m
//  PADTiltViewControllerExample
//
//  Created by Pavel Dusatko on 4/30/14.
//  Copyright (c) 2014 Pavel Dusatko. All rights reserved.
//

#import "PADCrawlDataSource.h"

static NSString *CellIdentifier = @"PADCrawlCell";

@interface PADCrawlDataSource ()

@property (nonatomic, strong) NSArray *array;

@end

@implementation PADCrawlDataSource

#pragma mark - Accessors

- (NSArray *)array {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"PADTiltViewControllerExample-Configuration" ofType:@"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        _array = dict[@"crawl"];
    });
    return _array;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id sectionInfo = self.array[section];
    return [sectionInfo count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.array[indexPath.section][indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
