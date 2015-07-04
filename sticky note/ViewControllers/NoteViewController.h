//
//  NoteViewController.h
//  sticky note
//
//  Created by Nguyen Minh Tu on 7/4/15.
//  Copyright (c) 2015 Apps Fellow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategoryModel;

@interface NoteViewController : UIViewController

+ (CategoryModel *)selectedCategory;
+ (void)setSelectedCategory:(CategoryModel *)category;

@property (weak, nonatomic) IBOutlet UIView *viewNoteCollectionHolder;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;

@end
