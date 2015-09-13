#import <UIKit/UIKit.h>

@class TodoTableViewCell;
@protocol TodoTableCellDelegate <NSObject>

- (void)saveTodoForCell:(TodoTableViewCell *)cell;
- (void)removeTodoForCell:(TodoTableViewCell *)cell;

@end

@interface TodoTableViewCell : UITableViewCell

typedef enum {
  EDITING = 1,
  DISABLED = 2
} STATES;

@property (weak, nonatomic) IBOutlet UITextField *txfTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;

@property (nonatomic, assign) id delegate;

- (void)enableEditting;
- (void)disableEditting;
- (void)shakeView;
- (IBAction)onSave:(id)sender;

@end
