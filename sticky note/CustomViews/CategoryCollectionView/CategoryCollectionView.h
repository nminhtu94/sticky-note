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

@class CategoryCollectionView;
@protocol CategoryCollectionDelegate <NSObject>

- (void)CategoryCollection:(CategoryCollectionView *)collection onItemSelected:(CategoryModel *)categoryItem;

@end
@interface CategoryCollectionView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, assign) id customDelegate;

@end
