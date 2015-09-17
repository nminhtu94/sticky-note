#import <UIKit/UIKit.h>

#import "CategoryModel.h"

@class ToDoModel;

@interface QuickToDoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *viewTodoTable;
@property (weak, nonatomic) IBOutlet UITextField *txfTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnAddTodo;
@property (weak, nonatomic) IBOutlet UIButton *btnCategory;
@property (weak, nonatomic) IBOutlet UIView *controlView;

@property (nonatomic, strong) ToDoModel *todoItem;
- (IBAction)onAddItem:(id)sender;
- (IBAction)onSave:(id)sender;
- (IBAction)onCancel:(id)sender;
- (IBAction)selectCategoryTapped:(id)sender;

@end
