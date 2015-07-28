#import <UIKit/UIKit.h>
#import "ImagePickerView.h"

@class DrawingPadView;
@interface QuickNoteViewController : UIViewController <ImagePickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *txvNoteText;
@property (weak, nonatomic) IBOutlet UIButton *btnChooseCategory;
@property (weak, nonatomic) IBOutlet UITextField *txfTitle;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet DrawingPadView *viewDrawingPad;
@property (weak, nonatomic) IBOutlet ImagePickerView *imagePicker;

- (IBAction)onSaveNote:(id)sender;
- (IBAction)onSelectCategory:(id)sender;
- (IBAction)onChangeInputMode:(id)sender;

@end
