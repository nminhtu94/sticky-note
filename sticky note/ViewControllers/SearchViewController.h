#import <UIKit/UIKit.h>
#import "ExpandableSearchBar.h"
#import "SearchTableViewCell.h"

@interface SearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblResult;
@property (weak, nonatomic) IBOutlet UISegmentedControl *searchSegment;

- (IBAction)searchSegmentChanged:(id)sender;

@end
