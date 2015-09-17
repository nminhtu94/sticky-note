#import "ToDoCollectionViewController.h"

#import "CategoryHelper.h"
#import "NoteHelper.h"
#import "TodoCollectionView.h"
#import "ToDoHelper.h"
#import "QuickToDoViewController.h"

@interface ToDoCollectionViewController () <TodoCollectionDelegate>

@property (nonatomic, strong) TodoCollectionView *todoCollection;

@end

static CategoryModel *selectedCategory;

@implementation ToDoCollectionViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  if (self.todoCollection == nil) {
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(75, 75);
    self.todoCollection =
        [[TodoCollectionView alloc] initWithFrame:self.todoCollectionHolder.bounds
                             collectionViewLayout:flowLayout];
    
    [self.todoCollection setBackgroundColor:[UIColor clearColor]];
    [self.todoCollectionHolder addSubview:self.todoCollection];
    [self.todoCollectionHolder bringSubviewToFront:self.todoCollection];
    [self.todoCollection setCustomDelegate:self];
  }
  
  [self setup];
}

+ (CategoryModel *)selectedCategory {
  return selectedCategory;
}

+ (void)setSelectedCategory:(CategoryModel *)category {
  selectedCategory = category;
}

- (void)setup {
  [self.todoCollection setData:[[ToDoHelper sharedInstance] getTodoOfCategory:selectedCategory]];
  [self.todoCollection reloadData];
  [self.backgroundImage setImage:[UIImage imageWithData:selectedCategory.icon]];
}

#pragma mark - TodoCollectionDelegate
- (void)todoCollectionView:(TodoCollectionView *)collectionView didSelectTodo:(ToDoModel *)todo {
  UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
  QuickToDoViewController *editTodoVC =
		[storyBoard instantiateViewControllerWithIdentifier:@"quickTodoVC"];
  [editTodoVC setTodoItem:todo];
  [self.navigationController pushViewController:editTodoVC animated:YES];
}

@end
