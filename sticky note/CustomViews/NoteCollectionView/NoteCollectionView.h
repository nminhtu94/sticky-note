//
//  NoteCollectionView.h
//  sticky note
//
//  Created by Nguyen Minh Tu on 7/4/15.
//  Copyright (c) 2015 Apps Fellow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteCollectionView : UICollectionView<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *notes;

@end
