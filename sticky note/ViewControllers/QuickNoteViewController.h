#import <UIKit/UIKit.h>
#import "ImagePickerView.h"

@class DrawingControl;
@class NoteModel;
@interface QuickNoteViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btnChooseCategory;
@property (weak, nonatomic) IBOutlet UITextField *txfTitle;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet ImagePickerView *imagePicker;
@property (weak, nonatomic) IBOutlet DrawingControl *drawingControlView;
@property (weak, nonatomic) IBOutlet UIView *alarm;

@property (weak, nonatomic) IBOutlet UIView *customTextView;
@property (weak, nonatomic) IBOutlet UITextField *txfTags;

@property (weak, nonatomic) IBOutlet UIButton *btnSelectImage;
@property (weak, nonatomic) IBOutlet UIImageView *imgNoteImage;
@property (weak, nonatomic) IBOutlet UIView *viewImageRefreshView;

@property (nonatomic, strong) NoteModel *note;
@property (nonatomic, assign) BOOL willResetData;
@property (weak, nonatomic) IBOutlet UIButton *cbAlarm;
@property (nonatomic, strong) NSDate *alarmDate;
@property (weak, nonatomic) IBOutlet UILabel *txDate;

- (IBAction)onSaveNote:(id)sender;
- (IBAction)onSelectCategory:(id)sender;
- (IBAction)onChangeInputMode:(id)sender;
- (IBAction)onDelete:(id)sender;
- (IBAction)onCancel:(id)sender;

- (IBAction)selectImage:(id)sender;
- (IBAction)replaceImage:(id)sender;

@end
