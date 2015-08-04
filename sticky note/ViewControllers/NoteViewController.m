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
		[_noteCollection setCustomDelegate:self];
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

#pragma mar <NoteCollectionDelegate>
- (void)noteCollectionView:(NoteCollectionView *)collectionView didSelectNote:(NoteModel *)note {
	/*
	[_viewNoteVC setNote:note];
	[self.navigationController pushViewController:_viewNoteVC animated:YES];
	 */
	UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main"
														 bundle:[NSBundle mainBundle]];
	QuickNoteViewController *editNoteVC = [storyBoard instantiateViewControllerWithIdentifier:@"quickNoteVC"];
	[editNoteVC setNote:note];
	[self.navigationController pushViewController:editNoteVC animated:YES];
}

@end
