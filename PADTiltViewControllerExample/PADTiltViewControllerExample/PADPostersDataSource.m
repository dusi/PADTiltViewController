//
//  PADPostersDataSource.m
//  PADTiltViewControllerExample
//
//  Created by Pavel Dusatko on 5/3/14.
//  Copyright (c) 2014 Pavel Dusatko. All rights reserved.
//

#import "PADPostersDataSource.h"

static NSString *CellIdentifier = @"PADPosterCell";

@interface PADPostersDataSource ()

@property (nonatomic, strong) NSArray *array;

@end

@implementation PADPostersDataSource

#pragma mark - Accessors

- (NSArray *)array {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"PADTiltViewControllerExample-Configuration" ofType:@"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        _array = dict[@"posters"];
    });
    return _array;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *dict = self.array[indexPath.row];
    
    UILabel *textLabel = (UILabel *)[cell viewWithTag:100];
    UITextField *detailTextField = (UITextField *)[cell viewWithTag:101];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:102];
    
    textLabel.text = dict[@"title"];
    detailTextField.text = dict[@"subtitle"];
    imageView.image = [UIImage imageNamed:dict[@"imageName"]];
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    return cell;
}

@end
