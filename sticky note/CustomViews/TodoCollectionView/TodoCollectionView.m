#import "TodoCollectionView.h"

#import "CAImageCollectionLayout.h"
#import "TodoCollectionViewCell.h"
#import "ToDoModel.h"

static NSString* const cellIdentifier = @"TodoCollectionCell";

@implementation TodoCollectionView
@synthesize data, customDelegate;

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
  self = [super initWithFrame:frame collectionViewLayout:layout];
  
  if (self) {
    // Initialization code
    NSArray *arrayOfViews =
    [[NSBundle mainBundle] loadNibNamed:@"TodoCollectionView" owner:self options:nil];
    
    if ([arrayOfViews count] < 1) {
      return nil;
    }
    
    if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[TodoCollectionView class]]) {
      return nil;
    }
    
    self = [arrayOfViews objectAtIndex:0];
    
    [self setFrame:frame];
  }
  
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  [self setup];
  [self setDelegate:self];
  [self setDataSource:self];
}

- (void)setup {
  [self registerNib:
      [UINib nibWithNibName:@"TodoCollectionViewCell"
                     bundle:[NSBundle mainBundle]]
      forCellWithReuseIdentifier:cellIdentifier];
  [self setBackgroundColor:[UIColor clearColor]];
  CAImageCollectionLayout* imageLayout = [[CAImageCollectionLayout alloc] init];
  [imageLayout setItemSize:CGSizeMake(100, 100)];
  [imageLayout setNumberOfColumns:self.frame.size.width / 100];
  [imageLayout setItemInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
  [self setCollectionViewLayout:imageLayout];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return self.data.count;
}

#pragma mark <UICollectionViewDelegate>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  TodoCollectionViewCell *cell =
		(TodoCollectionViewCell *)[self dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                                                        forIndexPath:indexPath];
  
  ToDoModel *todo = [self.data objectAtIndex:indexPath.row];
  [cell.lblTitle setText:todo.title];
  
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  ToDoModel *todo = (ToDoModel *)[self.data objectAtIndex:indexPath.row];
  
  if (customDelegate) {
    [customDelegate todoCollectionView:self didSelectTodo:todo];
  }
}

@end
