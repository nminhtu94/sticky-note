//
//  NoteViewController.m
//  sticky note
//
//  Created by Nguyen Minh Tu on 7/4/15.
//  Copyright (c) 2015 Apps Fellow. All rights reserved.
//

#import "NoteViewController.h"
#import "NoteCollectionView.h"
#import "NoteHelper.h"
#import "CategoryModel.h"

@interface NoteViewController ()

@property (nonatomic) NoteCollectionView *noteCollection;

@end

static CategoryModel *selectedCategory;
@implementation NoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setTitle:selectedCategory.name];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_noteCollection == nil) {
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(100, 100);
        _noteCollection = [[NoteCollectionView alloc] initWithFrame:_viewNoteCollectionHolder.bounds
                                               collectionViewLayout:flowLayout];
        [_noteCollection setBackgroundColor:[UIColor clearColor]];
        [_viewNoteCollectionHolder addSubview:_noteCollection];
        [_viewNoteCollectionHolder bringSubviewToFront:_noteCollection];
    }
    
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (CategoryModel *)selectedCategory {
    return selectedCategory;
}

+ (void)setSelectedCategory:(CategoryModel *)category {
    selectedCategory = category;
}

- (void)setup {
    [_noteCollection setNotes:[[NoteHelper sharedInstance] getNoteOfCategory:selectedCategory]];
    [_noteCollection reloadData];
    
    [_imgBackground setImage:[UIImage imageWithData:selectedCategory.icon]];
}


@end
