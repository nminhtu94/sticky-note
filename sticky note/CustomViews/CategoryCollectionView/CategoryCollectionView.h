//
//  CategoryCollectionView.h
//  sticky note
//
//  Created by Nguyen Minh Tu on 5/31/15.
//  Copyright (c) 2015 Apps Fellow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAImageCollectionLayout.h"
#import "CategoryCollectionViewCell.h"
#import "CategoryModel.h"

IB_DESIGNABLE
@interface CategoryCollectionView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *categories;

@end
