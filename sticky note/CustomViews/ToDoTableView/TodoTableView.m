#import "TodoTableView.h"

#import "ToDoModel.h"

static NSString* cellIdentifier = @"TodoTableCell";

@implementation TodoTableView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		// Initialization code
		NSArray *arrayOfViews =
			[[NSBundle mainBundle] loadNibNamed:@"TodoTableView" owner:self options:nil];
		
		if ([arrayOfViews count] < 1) {
			return nil;
		}
		
		if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[TodoTableView class]]) {
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
	 	[UINib nibWithNibName:@"TodoTableViewCell"
					   bundle:[NSBundle mainBundle]]
		forCellReuseIdentifier:cellIdentifier];
	[self setSeparatorColor:[UIColor clearColor]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	TodoTableViewCell *cell =
		(TodoTableViewCell *)[self dequeueReusableCellWithIdentifier:cellIdentifier
														forIndexPath:indexPath];
	
	NSString *todoItem = (NSString *)[self.data objectAtIndex:indexPath.row];
	
  [cell setDelegate:self];
	[cell.txfTitle setText:todoItem];
	[cell disableEditting];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 56.0f;
}

#pragma mark - <TodoTableCellDelegate>
- (void)saveTodoForCell:(TodoTableViewCell *)cell {
  NSString *lastData = self.data.lastObject;
  lastData = cell.txfTitle.text;
  [self.data replaceObjectAtIndex:self.data.count - 1 withObject:lastData];
  [cell disableEditting];
}

- (void)removeTodoForCell:(TodoTableViewCell *)cell {
  NSIndexPath *indexPath = [self indexPathForCell:cell];
  [self.data removeObjectAtIndex:indexPath.row];
  [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Private Methods
- (void)insertRowAtEnd {
	NSString *lastItem = [self.data lastObject];
	
	if ((lastItem == nil || [lastItem isEqualToString:@""])
		&& self.data.count > 0) {
		NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.data.count - 1 inSection:0];
		TodoTableViewCell *cell = (TodoTableViewCell *)[self cellForRowAtIndexPath:lastIndexPath];
		[cell shakeView];
		
		return;
	}
	[self.data addObject:[[NSString alloc] init]];
	NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.data.count - 1 inSection:0];
	
	[self insertRowsAtIndexPaths:@[lastIndexPath]
				withRowAnimation:UITableViewRowAnimationAutomatic];
	
	TodoTableViewCell *cell = (TodoTableViewCell *)[self cellForRowAtIndexPath:lastIndexPath];
	[cell enableEditting];
}

@end
