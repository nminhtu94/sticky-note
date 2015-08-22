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
@property (weak, nonatomic) IBOutlet UITextField *txfTags;

@property (nonatomic, strong) NoteModel *note;
@property (nonatomic, assign) BOOL willResetData;

- (IBAction)onSaveNote:(id)sender;
- (IBAction)onSelectCategory:(id)sender;
- (IBAction)onChangeInputMode:(id)sender;

@end
