#import <UIKit/UIKit.h>

@class ToDoModel;

@interface ToDoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *viewTodoTable;

@property (nonatomic, strong) ToDoModel *todoItem;
- (IBAction)onAddItem:(id)sender;
- (IBAction)onSave:(id)sender;
- (IBAction)onCancel:(id)sender;

@end
