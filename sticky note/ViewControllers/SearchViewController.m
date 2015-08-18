//
//  SearchViewController.m
//  sticky note
//
//  Created by Nguyen Minh Tu on 5/17/15.
//  Copyright (c) 2015 Apps Fellow. All rights reserved.
//

#import "SearchViewController.h"
#import "NoteHelper.h"
#import "NoteModel.h"
#import "QuickNoteViewController.h"
#import "Utility.h"

@interface SearchViewController () {
    ExpandableSearchBar *searchBar;
    NSArray *result;
}

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tblResult.delegate = self;
    self.tblResult.dataSource = self;
    self.tblResult.hidden = YES;
	
	// this will appear as the title in the navigation bar
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:20.0];
	label.textAlignment = NSTextAlignmentCenter;
	// ^-Use UITextAlignmentCenter for older SDKs.
	label.textColor = [UIColor whiteColor]; // change this color
	self.navigationItem.titleView = label;
	label.text = NSLocalizedString(@"Search", @"");
	[label sizeToFit];
	
	[self.navigationController.navigationBar setTranslucent:NO];
	[self.navigationController.navigationBar setBarTintColor:THEME_COLOR];
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view setBackgroundColor:THEME_COLOR_DARKER];
    [self.tblResult setBackgroundColor:THEME_COLOR_DARKER];
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
    searchBar.delegate = self;
    [self.navigationItem setTitleView:searchBar];
}

#pragma mark - Search protocol delegate
-(void) searchNote{
    NSString *searchKey = searchBar.txfQuery.text;
    result = [[NoteHelper sharedInstance] searchNote:searchKey];
    NSLog(@"Result search: %@", result);
    [self.tblResult reloadData];
    self.tblResult.hidden = NO;
}


#pragma mark uiTableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [result count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchTableViewCell *cell = [self.tblResult dequeueReusableCellWithIdentifier:@"myCell"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell setBackgroundColor:THEME_COLOR_DARKER];
    NoteModel *model = (NoteModel *) [result objectAtIndex:indexPath.row];
    cell.txtTitle.text = [NSString stringWithFormat:@"%@", model.title];
    cell.txtTitle.textColor = [UIColor whiteColor];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd"];
    cell.txtDate.text = [NSString stringWithFormat:@"%@", [format stringFromDate:model.date]];
    cell.txtDate.textColor = [UIColor whiteColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyBoard =
    [UIStoryboard storyboardWithName:@"Main"
                              bundle:[NSBundle mainBundle]];
    QuickNoteViewController *editNoteVC = [storyBoard instantiateViewControllerWithIdentifier:@"quickNoteVC"];
    [self.tblResult deselectRowAtIndexPath:indexPath animated:NO];
    [editNoteVC setNote:(NoteModel *) [result objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:editNoteVC animated:YES];
}

@end
