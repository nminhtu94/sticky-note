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

@interface CategoryViewController ()

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
        [self.viewCategoryTblHolder addSubview:self.tblCategory];
    }
    
    [self.tblCategory setCategories:[[CategoryHelper sharedInstance] getAllCategory]];
    [self.tblCategory reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onAddCategory:(id)sender {
    
}
@end
