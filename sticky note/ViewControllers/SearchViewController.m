//
//  SearchViewController.m
//  sticky note
//
//  Created by Nguyen Minh Tu on 5/17/15.
//  Copyright (c) 2015 Apps Fellow. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController () {
    ExpandableSearchBar *searchBar;
}

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setup];
}

- (void)setup {
    if (searchBar == nil) {
        searchBar = [[ExpandableSearchBar alloc] initWithFrame:
                     CGRectMake(0,
                                0,
                                self.navigationController.navigationBar.frame.size.width - 20,
                                30)];
        [searchBar setBackgroundColor:[UIColor whiteColor]];
        [searchBar setTitle:@"Search"];
        [searchBar.lblTitle setFont:[UIFont boldSystemFontOfSize:14.0]];
        [searchBar.lblTitle setTextColor:[UIColor blackColor]];
        
    }
    [self.navigationItem setTitleView:searchBar];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
