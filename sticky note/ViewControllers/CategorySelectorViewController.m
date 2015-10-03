#import "CategorySelectorViewController.h"

#import "NoteViewController.h"
#import "ToDoCollectionViewController.h"
#import "CategoryModel.h"
#import "EditCategoryViewController.h"

@interface CategorySelectorViewController ()

@property (nonatomic, strong) NoteViewController *noteVC;
@property (nonatomic, strong) ToDoCollectionViewController *todoVC;

@end

static CategoryModel *selectedCategory;

@implementation CategorySelectorViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
  
  if (self.noteVC == nil) {
    self.noteVC =
        (NoteViewController *)[storyBoard
            instantiateViewControllerWithIdentifier:@"noteViewController"];
  }
  
  if (self.todoVC == nil) {
    self.todoVC =
        (ToDoCollectionViewController *)[storyBoard
            instantiateViewControllerWithIdentifier:@"todoCollectionViewController"];
  }
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
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
  
  [NoteViewController setSelectedCategory:selectedCategory];
  [ToDoCollectionViewController setSelectedCategory:selectedCategory];
  [self.segmentControl setSelectedSegmentIndex:0];
  [self segmentControlChanged:self.segmentControl];
}

+ (CategoryModel *)selectedCategory {
  return selectedCategory;
}

+ (void)setSelectedCategory:(CategoryModel *)category {
  selectedCategory = category;
}

- (IBAction)segmentControlChanged:(id)sender {
  [self.noteVC removeFromParentViewController];
  [self.todoVC removeFromParentViewController];
  if (self.segmentControl.selectedSegmentIndex == 0) {
    [self.contentView addSubview:self.noteVC.view];
    [self addChildViewController:self.noteVC];
    [self.noteVC viewDidAppear:NO];
  } else if (self.segmentControl.selectedSegmentIndex == 1) {
    [self.contentView addSubview:self.todoVC.view];
    [self addChildViewController:self.todoVC];
    [self.todoVC viewDidAppear:NO];
  }
}

- (IBAction)cancelTapped:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editTapped:(id)sender {
  UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
  EditCategoryViewController *editCategoryVC =
      (EditCategoryViewController *)[storyBoard
            instantiateViewControllerWithIdentifier:@"editCategoryViewController"];
  [editCategoryVC setSelectedCategory:selectedCategory];
  [self.navigationController pushViewController:editCategoryVC animated:YES];
}

@end
