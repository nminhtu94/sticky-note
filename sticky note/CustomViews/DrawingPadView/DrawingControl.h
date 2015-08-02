#import <UIKit/UIKit.h>
#import "DrawingPadView.h"

@class DrawingControl;
@protocol DrawingControlDelegate <NSObject>

- (void)colorPickerTapped:(id)sender;

@end

@interface DrawingControl : UIView

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet DrawingPadView *drawingView;
@property (weak, nonatomic) IBOutlet UIButton *colorPickerButton;

@property (nonatomic, assign) id delegate;
- (IBAction)colorPickerButtonTapped:(id)sender;
- (IBAction)lineWithValueChanged:(id)sender;

@end
