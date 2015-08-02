#import "DrawingControl.h"

@implementation DrawingControl
@synthesize delegate;

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		NSString *className = NSStringFromClass([self class]);
		self.view = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] firstObject];
		[self.view setFrame:self.bounds];
		[self addSubview:self.view];
		return self;
	}
	return nil;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[self.colorPickerButton.layer setCornerRadius:3.0f];
}

- (IBAction)colorPickerButtonTapped:(id)sender {
	if (delegate) {
		[delegate colorPickerTapped:sender];
	}
}

- (IBAction)lineWithValueChanged:(id)sender {
	UISegmentedControl *segmentControl = (UISegmentedControl *)sender;
	switch ([segmentControl selectedSegmentIndex]) {
	  	case 0: {
			[_drawingView.path setLineWidth:1.0f];
			break;
	  	}
		case 1: {
			[_drawingView.path setLineWidth:2.0f];
			break;
		}
		case 2: {
			[_drawingView.path setLineWidth:3.0f];
			break;
		}
		case 3: {
			[_drawingView.path setLineWidth:4.0f];
			break;
		}
		case 4: {
			[_drawingView.path setLineWidth:5.0f];
			break;
		}
	}
}
@end
