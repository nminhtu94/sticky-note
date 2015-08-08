#import <UIKit/UIKit.h>
#import "ImagePickerView.h"

@class DrawingControl;
@class NoteModel;
@interface QuickNoteViewController : UIViewController <ImagePickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnChooseCategory;
@property (weak, nonatomic) IBOutlet UITextField *txfTitle;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet ImagePickerView *imagePicker;
@property (weak, nonatomic) IBOutlet DrawingControl *drawingControlView;
@property (weak, nonatomic) IBOutlet UIView *customTextView;

@property (nonatomic, strong) NoteModel *note;

- (IBAction)onSaveNote:(id)sender;
- (IBAction)onSelectCategory:(id)sender;
- (IBAction)onChangeInputMode:(id)sender;

@end
