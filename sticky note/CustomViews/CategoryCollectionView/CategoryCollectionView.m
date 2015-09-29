//
//  CategoryCollectionView.m
//  sticky note
//
//  Created by Nguyen Minh Tu on 5/31/15.
//  Copyright (c) 2015 Apps Fellow. All rights reserved.
//

#import "CategoryCollectionView.h"

@implementation CategoryCollectionView
@synthesize categories, customDelegate;

static NSString* cellIdentifier = @"CategoryCollectionCell";

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
  self = [super initWithFrame:frame collectionViewLayout:layout];
  
  if (self) {
    // Initialization code
    NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"CategoryCollectionView"
                                                          owner:self
                                                        options:nil];
    
    if ([arrayOfViews count] < 1) {
        return nil;
    }
    
    if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[CategoryCollectionView class]]) {
        return nil;
    }
    
    self = [arrayOfViews objectAtIndex:0];
    
    [self setFrame:frame];
  }
  
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  [self setup];
  [self setDelegate:self];
  [self setDataSource:self];
}

#pragma mark Custom-Methods
- (void)setup {
  [self registerNib:[UINib nibWithNibName:@"CategoryCollectionViewCell"
                                   bundle:[NSBundle mainBundle]]
      forCellWithReuseIdentifier:cellIdentifier];
  [self setBackgroundColor:[UIColor clearColor]];
  CAImageCollectionLayout* imageLayout = [[CAImageCollectionLayout alloc] init];
	[imageLayout setItemSize:CGSizeMake(120, 160)];
	[imageLayout setNumberOfColumns:self.frame.size.width / 120];
	[imageLayout setItemInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
  [self setCollectionViewLayout:imageLayout];
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView
  numberOfItemsInSection:(NSInteger)section {
  return categories.count;
}

#pragma mark UICollectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  CategoryCollectionViewCell *cell =
      (CategoryCollectionViewCell *)[self dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                                                    forIndexPath:indexPath];
  
  CategoryModel *category = [categories objectAtIndex:indexPath.row];
  [cell.lblName setText:category.name];
	[cell.lblName setTextColor:[UIColor whiteColor]];
  [cell.imgIcon setImage:[UIImage imageWithData:category.icon]];
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryModel *category = [categories objectAtIndex:indexPath.row];
    
    if (customDelegate) {
        [customDelegate CategoryCollection:self onItemSelected:category];
    }
}

@end
