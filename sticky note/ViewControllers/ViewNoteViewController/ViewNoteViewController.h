#import <UIKit/UIKit.h>
#import "ImagePickerView.h"

@class NoteModel;

@interface ViewNoteViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *drawingImage;
@property (weak, nonatomic) IBOutlet UIImageView *noteImage;
@property (weak, nonatomic) IBOutlet UITextView *noteText;

@property (nonatomic, strong) NoteModel *note;

@end
