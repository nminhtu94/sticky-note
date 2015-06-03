//
//  ImageCollectionLayout.h
//  ComparisionAap
//
//  Created by Nguyen minh Tuan on 10/15/14.
//  Copyright (c) 2014 Tanveer Ashraf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAImageCollectionLayout : UICollectionViewLayout

@property (nonatomic) UIEdgeInsets itemInsets;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat interItemSpacingY;
@property (nonatomic) NSInteger numberOfColumns;

@end
