#import "ImagePickerView.h"

@interface ImagePickerView()

@property (nonatomic, strong, readwrite) UIImage *selectedImage;

@end

@implementation ImagePickerView
@synthesize delegate = _delegate;

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];

	if (self) {
		NSString *className = NSStringFromClass([self class]);
		self.view = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] firstObject];
		[self.view setFrame:self.bounds];
		[self addSubview:self.view];
		return self;
	}
	
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.selectedImage = nil;
	[self.selectImageButton setHidden:NO];
	[self.imageView setHidden:YES];
	[[ImagePickerHelper sharedInstance] setDelegate:self];
}

- (IBAction)selectImage:(id)sender {
	if (_delegate) {
		[_delegate imagePickerView:self onSelectImage:sender];
	}
}

- (IBAction)replaceImage:(id)sender {
	if (_delegate) {
		[_delegate imagePickerView:self onReplaceImage:sender];
	}
}

- (void)onPicker:(UIImagePickerController *)picker
	didFinishPickingImageWithInfo:(NSDictionary *)info {
	UIImage *importedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
	
	[self.selectImageButton setHidden:YES];
	[self.imageView setHidden:NO];
	[self.imageView setImage:importedImage];
  [self.view bringSubviewToFront:self.imageView];
	self.selectedImage = importedImage;
	
	[[[ImagePickerHelper sharedInstance] picker] dismissViewControllerAnimated:YES completion:nil];
}

- (void)setImage:(UIImage *)image {
  [self.imageView setImage:image];
  [self.selectImageButton setHidden:YES];
  [self.imageView setHidden:NO];
}

- (void)reset {
	self.selectedImage = nil;
	[self.selectImageButton setHidden:NO];
	[self.imageView setHidden:YES];
	[self.imageView setImage:nil];
}

@end
