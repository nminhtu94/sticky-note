#import <UIKit/UIKit.h>

@interface DrawingPadView : UIView

@property (nonatomic, setter=setSketchImage:, getter=sketchImage) UIImage *incrementalImage;
@property (nonatomic) UIBezierPath *path;
@property (nonatomic, strong) UIColor *brushColor;

@end
