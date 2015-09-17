#import "CategoryViewController.h"

#import "CategoryCollectionView.h"
#import "CategoryHelper.h"
#import "NoteViewController.h"
#import "Utility.h"
#import "CategorySelectorViewController.h"

@interface CategoryViewController ()<CategoryCollectionDelegate>

@property (nonatomic, strong) CategoryCollectionView *tblCategory;

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	// this will appear as the title in the navigation bar
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:20.0];
	label.textAlignment = NSTextAlignmentCenter;
	// ^-Use UITextAlignmentCenter for older SDKs.
	label.textColor = [UIColor whiteColor]; // change this color
	self.navigationItem.titleView = label;
	label.text = NSLocalizedString(@"Sticky Note", @"");
	[label sizeToFit];
	
	[self.navigationController.navigationBar setTranslucent:NO];
	[self.navigationController.navigationBar setBarTintColor:THEME_COLOR];
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.view setBackgroundColor:THEME_COLOR_DARKER];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.tblCategory == nil) {
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(100, 100);
        self.tblCategory =
			[[CategoryCollectionView alloc] initWithFrame:self.viewCategoryTblHolder.bounds
									 collectionViewLayout:flowLayout];
        [self.tblCategory setCustomDelegate:self];
		[self.tblCategory setBackgroundColor:[UIColor clearColor]];
        [self.viewCategoryTblHolder addSubview:self.tblCategory];
		[self.viewCategoryTblHolder setBackgroundColor:[UIColor clearColor]];
    }
    
    [self.tblCategory setCategories:[[CategoryHelper sharedInstance] getAllCategory]];
    [self.tblCategory reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <CategoryCollectionDelegate>
- (void)CategoryCollection:(CategoryCollectionView *)collection
			onItemSelected:(CategoryModel *)categoryItem {
    [CategorySelectorViewController setSelectedCategory:categoryItem];
    [self performSegueWithIdentifier:@"toSelectorViewController" sender:self];
}

- (IBAction)onAddCategory:(id)sender {
    
}
@end
