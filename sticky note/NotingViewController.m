#import "NotingViewController.h"
#import "NEOColorPickerViewController.h"
#import "QuickNoteViewController.h"
#import "UIImage+ColorImage.h"

@interface NotingViewController () <NEOColorPickerViewControllerDelegate, UITextViewDelegate>

@property (nonatomic) NSArray *arrFont;
@property (nonatomic) NSArray *arrSize;
@property (nonatomic) BOOL colorPickerReturn;

- (UIFont *)getFont:(NSAttributedString *)text;
- (UIColor *)getColor:(NSAttributedString *)text;

@end

@implementation NotingViewController
@synthesize arrFont = arrFont;
@synthesize arrSize = arrSize;
@synthesize text = _text;

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  arrFont = [UIFont familyNames];
  arrSize = [[NSArray alloc] initWithObjects:@"9", @"10", @"11", @"12", @"13", @"14", @"18", @"24", @"36", @"48", @"64", @"72", @"96", @"144", @"288", nil];
  
  /* init pickerView */
  self.viewOfPickerView.hidden = YES;
  self.pickerView.dataSource = self;
  self.pickerView.delegate = self;

  UIBarButtonItem *pickerViewCancel =
  [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                   style:UIBarButtonItemStyleDone
                  target:self
                  action:@selector(clickPickerViewCancel)];
  
  UIBarButtonItem *pickerViewSpace =
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                              target:nil
                              action:nil];
  UIBarButtonItem *pickerViewDone =
      [[UIBarButtonItem alloc] initWithTitle:@"Done"
                       style:UIBarButtonItemStyleDone
                      target:self
                      action:@selector(clickPickerViewDone)];

  [self.toolbar setItems:[[NSArray alloc] initWithObjects:pickerViewCancel,
            pickerViewSpace,
            pickerViewDone,
            nil]];
  [self.toolbar isUserInteractionEnabled];
	
	UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:
						  CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 30)];
	toolbar.barStyle = UIBarStyleDefault;
	[toolbar sizeToFit];
	
	NSMutableArray *barItems = [[NSMutableArray alloc] init];
	UIBarButtonItem *flexibleSpace =
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                    target:nil
                                                    action:nil];
	UIBarButtonItem *doneBtn =
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                    target:self
                                                    action:@selector(textViewDone:)];
	[barItems addObject:flexibleSpace];
	[barItems addObject:doneBtn];
	[toolbar setItems:barItems animated:YES];
	
	[self.textView setInputAccessoryView:toolbar];
  [self.textView setDelegate:self];
  [self.view bringSubviewToFront:self.textView];
  [self.view bringSubviewToFront:self.viewOfPickerView];
	
    /* set up button Done on right */
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done"
															 style:UIBarButtonItemStyleDone
															target:self
															action:@selector(clickDone)];
    self.navigationItem.rightBarButtonItem = done;
}

- (void)textViewDone:(id)sender {
	[self.textView resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  if (!self.colorPickerReturn) {
    if (_text != nil) {
      [self.btnFont setTitle:[self getFont:_text].fontName forState:UIControlStateNormal];
      [self.btnSize setTitle:[NSString stringWithFormat:@"%0.f",
                              [self getFont:_text].pointSize]
                    forState:UIControlStateNormal];
      [self.btnColor setBackgroundColor:[self getColor:_text]];
      [self.textView setFont:[self getFont:_text]];
      [self.textView setAttributedText:_text];
    } else {
      UIFont *font = [UIFont fontWithName:@"Helvetica" size:14.0];
      [self.textView setFont:font];
      [self.textView setTextColor:[UIColor blackColor]];
      _text = [self.textView attributedText];
      [self.btnFont setTitle:font.fontName forState:UIControlStateNormal];
      [self.btnSize setTitle:[NSString stringWithFormat:@"%0.f", font.pointSize]
                    forState:UIControlStateNormal];
      [self.btnColor setBackgroundColor:[UIColor blackColor]];
    }
  } else {
    self.colorPickerReturn = NO;
  }
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

#pragma mark PickerView
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView
             attributedTitleForRow:(NSInteger)row
                      forComponent:(NSInteger)component {
  if (component == 0) {
    return [[NSAttributedString alloc] initWithString:[arrFont objectAtIndex:row]
                                           attributes:
            @{NSFontAttributeName : [UIFont fontWithName:[arrFont objectAtIndex:row] size:9]}];
  } else {
    return [[NSAttributedString alloc] initWithString:[arrSize objectAtIndex:row]];
  }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
  return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
  if (component == 0) {
    return [arrFont count];
  } else {
    return [arrSize count];
  }
}

-(void)pickerView:(UIPickerView *)pickerView
	 didSelectRow:(NSInteger)row
	  inComponent:(NSInteger)component{
  NSLog(@"Row select: %ld",(long)row );
  NSInteger fristRow = [self.pickerView selectedRowInComponent:0];
  NSInteger secondRow = [self.pickerView selectedRowInComponent:1];

  NSString *fontName = [arrFont objectAtIndex:fristRow];
  NSString *size = [arrSize objectAtIndex:secondRow];
	UIFont *font = [UIFont fontWithName:[NSString stringWithFormat:@"%@", fontName]
								   size:[size floatValue]];
	[self.btnFont setTitle:font.fontName forState:UIControlStateNormal];
	[self.btnSize setTitle:[NSString stringWithFormat:@"%0.f", font.pointSize]
                forState:UIControlStateNormal];
  [self.textView setFont:font];
}

-(void) clickPickerViewDone{
    self.viewOfPickerView.hidden = YES;
    /* TO-DO something */
}

-(void) clickPickerViewCancel{
    self.viewOfPickerView.hidden = YES;
}

#pragma mark - <UITextViewDelegate>
- (BOOL)textView:(UITextView *)textView
    shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
  _text = textView.attributedText;
  return YES;
}

#pragma mark <NEOColorPickerViewControllerDelegate>
- (void)colorPickerViewController:(NEOColorPickerBaseViewController *)controller
				   didChangeColor:(UIColor *)color {
	[self.textView setTextColor:color];
	[self.btnColor setBackgroundColor:color];
	self.colorPickerReturn = YES;
	QuickNoteViewController *pView = (QuickNoteViewController *)[self parentViewController];
	[pView setWillResetData:NO];
	[controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)colorPickerViewController:(NEOColorPickerBaseViewController *)controller
				   didSelectColor:(UIColor *)color {
	[self.textView setTextColor:color];
	[self.btnColor setBackgroundColor:color];
	self.colorPickerReturn = YES;
	QuickNoteViewController *pView = (QuickNoteViewController *)[self parentViewController];
	[pView setWillResetData:NO];
	[controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)colorPickerViewControllerDidCancel:(NEOColorPickerBaseViewController *)controller {
	self.colorPickerReturn = YES;
	[controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark
-(void) clickDone{
  [self.textView resignFirstResponder];
  self.pickerView.hidden = YES;
}

- (IBAction)actionFont:(id)sender {
    self.viewOfPickerView.hidden = !self.viewOfPickerView.hidden;
	
	if (![self.viewOfPickerView isHidden]) {
		NSUInteger index = 0;
		NSString *fontName = [self getFont:_text].fontName;
		for (index = 0; index < arrFont.count; index++) {
			if ([[arrFont objectAtIndex:index] isEqualToString:fontName]) {
				break;
			}
		}
		[self.pickerView selectRow:index inComponent:0 animated:YES];
		
		index = 0;
		NSString *fontSize = [NSString stringWithFormat:@"%0.f", [self getFont:_text].pointSize];
		for (index = 0; index < arrSize.count; index++) {
			if ([[arrSize objectAtIndex:index] isEqualToString:fontSize]) {
				break;
			}
		}
		[self.pickerView selectRow:index inComponent:1 animated:YES];
	}
}
- (IBAction)actionSize:(id)sender {
  self.viewOfPickerView.hidden = !self.viewOfPickerView.hidden;
	
	if (![self.viewOfPickerView isHidden]) {
		NSUInteger index = 0;
		NSString *fontName = [self getFont:_text].fontName;
		for (index = 0; index < arrFont.count; index++) {
			if ([[arrFont objectAtIndex:index] isEqualToString:fontName]) {
				break;
			}
		}
		[self.pickerView selectRow:index inComponent:0 animated:YES];
		
		index = 0;
		NSString *fontSize = [NSString stringWithFormat:@"%0.f", [self getFont:_text].pointSize];
		for (index = 0; index < arrSize.count; index++) {
			if ([[arrSize objectAtIndex:index] isEqualToString:fontSize]) {
				break;
			}
		}
		[self.pickerView selectRow:index inComponent:1 animated:YES];
	}
}

- (IBAction)actionColor:(id)sender {
	NEOColorPickerViewController *controller = [[NEOColorPickerViewController alloc] init];
	controller.delegate = self;
	[controller setSelectedColor:[UIColor blackColor]];
	controller.title = @"Select brush color";
	UINavigationController* navVC =
	[[UINavigationController alloc] initWithRootViewController:controller];
	_text = self.textView.attributedText;
	[self.parentViewController presentViewController:navVC animated:YES completion:nil];
}

- (UIFont *)getFont:(NSAttributedString *)text {
	NSRange range = NSMakeRange(0, text.length);
	if (text.length == 0) {
		return self.textView.font;
	}
	
	UIFont *fontAttribute = [text attribute:NSFontAttributeName
									 atIndex:0
							  effectiveRange:&range];
	return fontAttribute;
}

- (UIColor *)getColor:(NSAttributedString *)text {
	NSRange range = NSMakeRange(0, text.length);
	if (text.length == 0) {
		return [UIColor blackColor];
	}
	
	UIColor *color =
		[text attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:&range];
	return color != nil ? color : [UIColor blackColor];
}

@end
