//
//  CategoryViewController.m
//  sticky note
//
//  Created by Nguyen Minh Tu on 5/17/15.
//  Copyright (c) 2015 Apps Fellow. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryCollectionView.h"
#import "CategoryHelper.h"
#import "NoteViewController.h"

@interface CategoryViewController ()<CategoryCollectionDelegate>

@property (nonatomic, strong) CategoryCollectionView *tblCategory;

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.tblCategory == nil) {
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(100, 100);
        self.tblCategory = [[CategoryCollectionView alloc] initWithFrame:self.viewCategoryTblHolder.bounds
                                                    collectionViewLayout:flowLayout];
        [self.tblCategory setCustomDelegate:self];
        [self.viewCategoryTblHolder addSubview:self.tblCategory];
    }
    
    [self.tblCategory setCategories:[[CategoryHelper sharedInstance] getAllCategory]];
    [self.tblCategory reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <CategoryCollectionDelegate>
- (void)CategoryCollection:(CategoryCollectionView *)collection onItemSelected:(CategoryModel *)categoryItem {
    [NoteViewController setSelectedCategory:categoryItem];
    [self performSegueWithIdentifier:@"toNoteViewController" sender:self];
}

- (IBAction)onAddCategory:(id)sender {
    
}
@end
