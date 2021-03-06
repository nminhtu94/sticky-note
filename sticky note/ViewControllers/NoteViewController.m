#import "NoteViewController.h"
#import "NoteCollectionView.h"

#import "NoteHelper.h"
#import "ViewNoteViewController.h"
#import "CategoryModel.h"
#import "QuickNoteViewController.h"

@interface NoteViewController () <NoteCollectionViewDelegate>

@property (nonatomic) NoteCollectionView *noteCollection;
@property (nonatomic) ViewNoteViewController *viewNoteVC;

@end

static CategoryModel *selectedCategory;

@implementation NoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (_viewNoteVC == nil) {
		_viewNoteVC = [[ViewNoteViewController alloc] init];
	}
	
	UIBarButtonItem *backButton =
		[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
													  target:self
													  action:@selector(backButtonTapped)];
	[backButton setTintColor:[UIColor whiteColor]];
	[self.navigationItem setLeftBarButtonItem:backButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  if (_noteCollection == nil) {
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(75, 75);
    _noteCollection =
        [[NoteCollectionView alloc] initWithFrame:_viewNoteCollectionHolder.bounds
                             collectionViewLayout:flowLayout];
    [_noteCollection setBackgroundColor:[UIColor clearColor]];
    [_viewNoteCollectionHolder addSubview:_noteCollection];
    [_viewNoteCollectionHolder bringSubviewToFront:_noteCollection];
    [_noteCollection setCustomDelegate:self];
  }
	
	// this will appear as the title in the navigation bar
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:20.0];
	label.textAlignment = NSTextAlignmentCenter;
	// ^-Use UITextAlignmentCenter for older SDKs.
	label.textColor = [UIColor whiteColor]; // change this color
	self.navigationItem.titleView = label;
	label.text = NSLocalizedString(selectedCategory.name, @"");
	[label sizeToFit];
    
  [self setup];
}

+ (CategoryModel *)selectedCategory {
    return selectedCategory;
}

+ (void)setSelectedCategory:(CategoryModel *)category {
    selectedCategory = category;
}

- (void)backButtonTapped {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)setup {
  [_noteCollection setNotes:[[NoteHelper sharedInstance] getNoteOfCategory:selectedCategory]];
  [_noteCollection reloadData];
  
  if (selectedCategory.icon) {
    [_imgBackground setImage:[UIImage imageWithData:selectedCategory.icon]];
  } else {
    [_imgBackground setImage:nil];
  }
}

#pragma mar <NoteCollectionDelegate>
- (void)noteCollectionView:(NoteCollectionView *)collectionView didSelectNote:(NoteModel *)note {
	UIStoryboard *storyBoard =
      [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
	QuickNoteViewController *editNoteVC =
		[storyBoard instantiateViewControllerWithIdentifier:@"quickNoteVC"];
	[editNoteVC setNote:note];
	[self.navigationController pushViewController:editNoteVC animated:YES];
}

@end
