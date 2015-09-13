#import <UIKit/UIKit.h>

#import "TodoTableViewCell.h"

@interface TodoTableView : UITableView <UITableViewDataSource, UITableViewDelegate,
                                        TodoTableCellDelegate>

@property (nonatomic, strong) NSMutableArray *data;

- (void)insertRowAtEnd;

@end
