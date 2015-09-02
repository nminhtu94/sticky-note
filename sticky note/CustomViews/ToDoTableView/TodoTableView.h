#import <UIKit/UIKit.h>

@interface TodoTableView : UITableView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *data;

@end
