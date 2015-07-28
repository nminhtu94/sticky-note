#import <UIKit/UIKit.h>
#import "ImagePickerHelper.h"

@class ImagePickerView;
@protocol ImagePickerViewDelegate <NSObject>

- (void)imagePickerView:(ImagePickerView *)pickerView onSelectImage:(id)sender;
- (void)imagePickerView:(ImagePickerView *)pickerView onReplaceImage:(id)sender;

@end

@interface ImagePickerView : UIView <ImagePickerHelperDelegate>

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIButton *selectImageButton;
@property (weak, nonatomic) IBOutlet UIButton *replaceButton;
@property (weak, nonatomic) IBOutlet UIButton *replaceIconButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, assign) id delegate;
@property (nonatomic, strong, readonly) UIImage *selectedImage;

- (IBAction)selectImage:(id)sender;
- (IBAction)replaceImage:(id)sender;

- (void)reset;

@end
