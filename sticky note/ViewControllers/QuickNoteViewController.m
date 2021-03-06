#import "QuickNoteViewController.h"
#import "NoteHelper.h"
#import "CategoryHelper.h"
#import "MainTabBarViewController.h"
#import "DrawingControl.h"
#import "NEOColorPickerViewController.h"
#import "NotingViewController.h"
#import "Utility.h"
#import "AlarmViewController.h"

@interface QuickNoteViewController () <UIPickerViewDelegate,
                                       UIPickerViewDataSource,
                                       DrawingControlDelegate,
                                       UITextFieldDelegate,
                                       UIAlertViewDelegate,
                                       ImagePickerHelperDelegate,
                                       NEOColorPickerViewControllerDelegate>

@property (nonatomic) UIPickerView *pickerViewCategory;
@property (nonatomic, assign, getter=isPickerViewTogged) BOOL pickerViewTogged;
@property (nonatomic, assign) CGRect categoryPickerFrameOriginal;
@property (nonatomic, assign) CGRect categoryPickerFrameMoved;
@property (nonatomic) UIAlertView *alertView;
@property (nonatomic) CategoryModel *selectedCategory;
@property (nonatomic) UIAlertController *actionSheet;
@property (nonatomic) CGRect viewOriginalFrame;
@property (nonatomic) UIView *inputView;

@property (nonatomic, strong) NotingViewController *txvNotingView;



@end

@implementation QuickNoteViewController
@synthesize inputView;

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  if (_alertView == nil) {
      _alertView = [[UIAlertView alloc] initWithTitle:@"Sticky Notes"
                                              message:@""
                                             delegate:nil
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil, nil];
  }

	if (_actionSheet == nil) {
    _actionSheet = [UIAlertController alertControllerWithTitle:@"Photos"
                                                       message:@"Select your photos source"
                                                preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* library = [UIAlertAction actionWithTitle:@"Library"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action)
    {
      [self presentViewController:
          [[ImagePickerHelper sharedInstance]
              pickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary]
                         animated:YES
                       completion:nil];
      [[ImagePickerHelper sharedInstance] setDelegate:self];
      self.willResetData = NO;
    }];
    UIAlertAction* camera = [UIAlertAction actionWithTitle:@"Camera"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action)
    {
      self.willResetData = NO;
      [self presentViewController:
          [[ImagePickerHelper sharedInstance]
              pickerWithSourceType:UIImagePickerControllerSourceTypeCamera]
                         animated:YES
                       completion:nil];
      [[ImagePickerHelper sharedInstance] setDelegate:self];
    }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action)
    {
      [_actionSheet dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [_actionSheet addAction:library];
    [_actionSheet addAction:camera];
    [_actionSheet addAction:cancel];
	}
	
	[self.txfTitle setReturnKeyType:UIReturnKeyDone];
	[self.txfTitle setDelegate:self];
	self.willResetData = YES;
  
  [self.alarm setBackgroundColor:THEME_COLOR_DARKER];
	// this will appear as the title in the navigation bar
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:20.0];
	label.textAlignment = NSTextAlignmentCenter;
	// ^-Use UITextAlignmentCenter for older SDKs.
	label.textColor = [UIColor whiteColor]; // change this color
	self.navigationItem.titleView = label;
	label.text = NSLocalizedString(@"Sticky Notes", @"");
	[label sizeToFit];
	
	[self.navigationController.navigationBar setTranslucent:NO];
	[self.navigationController.navigationBar setBarTintColor:THEME_COLOR];
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	
	[self addEventToViews];
  
  dispatch_async(dispatch_get_main_queue(), ^{
    // get Alarm from database
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"EEEE-MM-dd-yyyy HH:mm"];
    [self.txDate setText:[dateFormater stringFromDate:self.note.alarm]];
    self.txDate.textColor = [UIColor whiteColor];
    self.txDate.hidden = NO;
    if ([self.txDate.text length] > 0 ) {
      [self.cbAlarm setBackgroundImage:[UIImage imageNamed:@"checked_checkbox"]
                              forState:UIControlStateNormal];
    } else {
      [self.cbAlarm setBackgroundImage:[UIImage imageNamed:@"checkbox"]
                              forState:UIControlStateNormal];
    }
  });
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
	if (self.willResetData) {
		[self resetData];
    self.willResetData = NO;
	}
  
	[self.view setBackgroundColor:THEME_COLOR_DARKER];
	
	[self.txfTitle setBackgroundColor:THEME_COLOR_DARKER];
	[self.txfTitle setTextColor:[UIColor whiteColor]];
	[self.txfTitle.layer setBorderWidth:3.0f];
  [self.txfTitle.layer setCornerRadius:5.0f];
	[self.txfTitle.layer setBorderColor:[UIColor whiteColor].CGColor];
	[self.txfTitle setClipsToBounds:YES];
  [self.txfTitle setAttributedPlaceholder:
      [[NSAttributedString alloc] initWithString:@"Enter title"
                                      attributes:
          @{NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
	
	[self.btnChooseCategory.layer setCornerRadius:5.0f];
	[self.btnChooseCategory setClipsToBounds:YES];
  
  if (_txvNotingView == nil) {
    _txvNotingView = [[NotingViewController alloc] init];
    [self addChildViewController:_txvNotingView];
    [_txvNotingView.view setFrame:self.customTextView.bounds];
    [self.customTextView addSubview:_txvNotingView.view];
  }
  
  // Alarm
  if (self.alarmDate) {
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"EEEE-MM-dd-yyyy HH:mm"];
    NSString *tmp = [dateFormater stringFromDate:self.alarmDate];
    
    self.txDate.text = tmp;
    self.txDate.hidden = NO;
  }
  
  [self.btnSelectImage setHidden:NO];
  [self.imgNoteImage setHidden:YES];
  [self.viewImageRefreshView setHidden:YES];
  [self.txfTags setDelegate:self];
  [self.txfTags setReturnKeyType:UIReturnKeyDone];
  
  if (self.note != nil) {
    self.willResetData = NO;
    [self.drawingControlView.drawingView setSketchImage:
     [UIImage imageWithData:self.note.sketch]];
    [self.txvNotingView.textView setAttributedText:self.note.text];
    [self.txvNotingView setText:self.note.text];
    [self.txfTitle setText:self.note.title];
    
    if (self.note.image != nil) {
      [self.imgNoteImage setImage:[UIImage imageWithData:self.note.image]];
      [self.btnChooseCategory setHidden:YES];
      [self.imgNoteImage setHidden:NO];
      [self.viewImageRefreshView setHidden:NO];
    }
    
    [self.drawingControlView.drawingView setNeedsDisplay];
    [self.txfTags setText:[AppUtil generateStrings:self.note.tags]];
    
    NSLog(@"Did Appear Alarm : %@", self.txDate.text);
    if (self.alarmDate != nil) {
      if ([self.txDate.text length] > 0) {
        [self.cbAlarm setBackgroundImage:[UIImage imageNamed:@"checked_checkbox"]
                                forState:UIControlStateNormal];
      } else {
        [self.cbAlarm setBackgroundImage:[UIImage imageNamed:@"checkbox"]
                                forState:UIControlStateNormal];
      }
    }
  }
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [self.view setNeedsDisplay];
  [self.view layoutIfNeeded];
  
  if (inputView == nil) {
    [self createInputView];
  }
  
  _categoryPickerFrameOriginal = CGRectMake(0,
                                            self.view.frame.size.height,
                                            inputView.frame.size.width,
                                            inputView.frame.size.height);
	
	[self.drawingControlView.layer setBorderColor:[UIColor blackColor].CGColor];
	[self.drawingControlView.layer setBorderWidth:1.0f];
	[self.drawingControlView setDelegate:self];
	
  [inputView setFrame:_categoryPickerFrameOriginal];
  [_pickerViewCategory reloadAllComponents];
	
	self.viewOriginalFrame = self.view.frame;
  
  // Alarm
  self.alarmDate = nil;
}

- (void)createInputView {
  CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
  CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
  
  UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 30)];
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
                                                    action:@selector(pickerDoneTapped)];
  [doneBtn setTintColor:[UIColor whiteColor]];
  
  [toolbar setBarTintColor:THEME_COLOR];
  [barItems addObject:flexibleSpace];
  [barItems addObject:doneBtn];
  [toolbar setItems:barItems animated:YES];
  
  _pickerViewCategory = [[UIPickerView alloc] init];
  [_pickerViewCategory setFrame:CGRectMake(0, 30, screenWidth, 250)];
  
  // Create a category picker view.
  [_pickerViewCategory setBackgroundColor:THEME_COLOR_DARKER];
  [_pickerViewCategory setTintColor:[UIColor whiteColor]];
  [_pickerViewCategory setDelegate:self];
  [_pickerViewCategory setDataSource:self];
  [_pickerViewCategory.layer setBorderWidth:3.0f];
  [_pickerViewCategory.layer setBorderColor:[UIColor whiteColor].CGColor];
  [_pickerViewCategory setShowsSelectionIndicator:YES];
  
  inputView =
      [[UIView alloc] initWithFrame:CGRectMake(0,
                                               screenHeight,
                                               screenWidth,
                                               toolbar.frame.size.height +
                                               _pickerViewCategory.frame.size.height)];
  inputView.backgroundColor = [UIColor clearColor];
  [inputView addSubview:_pickerViewCategory];
  [inputView addSubview:toolbar];
  
  [self.view addSubview:inputView];
}

#pragma mark <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
  [self.txfTags resignFirstResponder];
	return YES;
}

#pragma mark <UIPickerViewDelegate>
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
  if (row == 0) {
    [self.btnChooseCategory setTitle:@"Select category" forState:UIControlStateNormal];
    return;
  }
  
  NSArray *allCategory = [[CategoryHelper sharedInstance] getAllCategory];
  _selectedCategory = [allCategory objectAtIndex:row - 1];
  
  [_btnChooseCategory setTitle:_selectedCategory.name forState:UIControlStateNormal];
}

#pragma mark <UIPickerViewDataSource>
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView
             attributedTitleForRow:(NSInteger)row
					  forComponent:(NSInteger)component {
  if (row == 0) {
    return [[NSAttributedString alloc] initWithString:@"Select category"
                                           attributes:
        @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
  }
  
	NSArray *allCategory = [[CategoryHelper sharedInstance] getAllCategory];
	CategoryModel *category = [allCategory objectAtIndex:row - 1];
	
	NSAttributedString *attString =
		[[NSAttributedString alloc] initWithString:category.name
                                    attributes:
  			@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
	return attString;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[CategoryHelper sharedInstance] getAllCategory].count + 1;
}

#pragma mark <DrawingControlDelegate>
- (void)colorPickerTapped:(id)sender {
	NEOColorPickerViewController *controller = [[NEOColorPickerViewController alloc] init];
	controller.delegate = self;
	[controller setSelectedColor:[UIColor blackColor]];
	controller.title = @"Select brush color";
	UINavigationController* navVC =
		[[UINavigationController alloc] initWithRootViewController:controller];
	self.willResetData = NO;
	[self presentViewController:navVC animated:YES completion:nil];
}

#pragma mark <NEOColorPickerViewControllerDelegate>
- (void)colorPickerViewController:(NEOColorPickerBaseViewController *)controller
                   didChangeColor:(UIColor *)color {
	[self.drawingControlView.drawingView setBrushColor:color];
	[self.drawingControlView.colorPickerButton setBackgroundColor:color];
	[controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)colorPickerViewController:(NEOColorPickerBaseViewController *)controller
                   didSelectColor:(UIColor *)color {
	[self.drawingControlView.drawingView setBrushColor:color];
	[self.drawingControlView.colorPickerButton setBackgroundColor:color];
	[controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)colorPickerViewControllerDidCancel:(NEOColorPickerBaseViewController *)controller {
	[controller dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onSaveNote:(id)sender {
  if ([_txfTitle.text isEqualToString:@""]) {
    [_alertView setMessage:@"Please enter title!"];
    [_alertView show];
    return;
  }
  
  if (_selectedCategory == nil) {
    [_alertView setMessage:@"Please select category!"];
    [_alertView show];
    return;
  }
	
	UIImage *sketch = [_drawingControlView.drawingView sketchImage];
	
	if (_note == nil) {
    NSDate *alarm = nil;
    
    // alarm
    if (self.txDate.text.length > 0) {
      // Schedule the notification
      NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
      [dateFormater setDateFormat:@"EEEE-MM-dd-yyyy HH:mm"];
      self.alarmDate = [dateFormater dateFromString:self.txDate.text];
      alarm = self.alarmDate;
      
      UILocalNotification *localNotification = [[UILocalNotification alloc] init];
      localNotification.fireDate = self.alarmDate;
      
      localNotification.alertBody = _txfTitle.text;
      localNotification.alertTitle = @"Alarm";
      localNotification.alertAction = @"Alert";
      localNotification.timeZone = [NSTimeZone defaultTimeZone];
      localNotification.applicationIconBadgeNumber =
          [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
      localNotification.soundName = UILocalNotificationDefaultSoundName;
      localNotification.applicationIconBadgeNumber = 1;
      [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }

    [[NoteHelper sharedInstance] addNote:_txfTitle.text
                                    text:_txvNotingView.textView.attributedText
                                   image:UIImagePNGRepresentation(self.imgNoteImage.image)
                                  sketch:UIImagePNGRepresentation(sketch)
                                    date:[NSDate date]
                                category:_selectedCategory
                                    tags:[AppUtil parseDataFromString:self.txfTags.text]
                                   alarm:alarm];

    self.willResetData = YES;
		[self resetData];
	} else {
    UIImage *selectedImage = self.imgNoteImage.image;
    NSDate *date = nil;
    // alarm
    if (self.txDate.text.length > 0) {
      // Schedule the notification
      NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
      [dateFormater setDateFormat:@"EEEE-MM-dd-yyyy HH:mm"];
      self.alarmDate = [dateFormater dateFromString:self.txDate.text];
      date = self.alarmDate;
      
      UILocalNotification* localNotification = [[UILocalNotification alloc] init];
      localNotification.fireDate = self.alarmDate;
      
      localNotification.alertBody = _txfTitle.text;
      localNotification.alertTitle = @"Alarm";
      localNotification.alertAction = @"Alert";
      localNotification.timeZone = [NSTimeZone defaultTimeZone];
      localNotification.applicationIconBadgeNumber =
          [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
      localNotification.soundName = UILocalNotificationDefaultSoundName;
      localNotification.applicationIconBadgeNumber = 1;
      [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
  
    [[NoteHelper sharedInstance] updateNote:_note.objectID
                                      title:_txfTitle.text
                                       text:_txvNotingView.textView.attributedText
                                      image:UIImagePNGRepresentation(selectedImage)
                                     sketch:UIImagePNGRepresentation(sketch)
                                       date:[NSDate date]
                                   category:_selectedCategory
                                       tags:[AppUtil parseDataFromString:self.txfTags.text]
                                      alarm:date];
    [self.navigationController popViewControllerAnimated:YES];
    
  }
	[AppUtil showAlert:@"Sticky Notes" message:@"Note saved successfully"];
	[self resignFirstResponder];
}

- (IBAction)onSelectCategory:(id)sender {
  if ([[CategoryHelper sharedInstance] getAllCategory].count == 0) {
    [_alertView setMessage:@"You don't have any category, please create some"];
    [_alertView show];
    return;
  }
  
  [self.txfTitle resignFirstResponder];
  
  if (!_pickerViewTogged) {
    _categoryPickerFrameMoved =
        CGRectMake(0,
               self.view.frame.size.height - _pickerViewCategory.frame.size.height,
               _pickerViewCategory.frame.size.width,
               _pickerViewCategory.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
      [inputView setFrame:_categoryPickerFrameMoved];
    } completion:^(BOOL finished) {
      _pickerViewTogged = YES;
    }];
  } else {
    _categoryPickerFrameOriginal =
        CGRectMake(0,
               self.view.frame.size.height,
               _pickerViewCategory.frame.size.width,
               _pickerViewCategory.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
      [inputView setFrame:_categoryPickerFrameOriginal];
    } completion:^(BOOL finished) {
      _pickerViewTogged = NO;
    }];
  }
}

- (IBAction)onChangeInputMode:(id)sender {
	UISegmentedControl *selector = (UISegmentedControl *)sender;
	if ([selector selectedSegmentIndex] == 0) {
		[self.customTextView setHidden:NO];
		[_drawingControlView setHidden:YES];
		[_imagePicker setHidden:YES];
    [self.alarm setHidden:YES];
	} else if ([selector selectedSegmentIndex] == 1) {
		[self.customTextView setHidden:YES];
		[_imagePicker setHidden:YES];
		[_drawingControlView setHidden:NO];
      [self.alarm setHidden:YES];
	} else if ([selector selectedSegmentIndex] == 2) {
		[self.customTextView setHidden:YES];
		[_imagePicker setHidden:NO];
		[_drawingControlView setHidden:YES];
    [self.alarm setHidden:YES];
  } else if ([selector selectedSegmentIndex] == 3) {
    [self.customTextView setHidden:YES];
    [_imagePicker setHidden:YES];
    [_drawingControlView setHidden:YES];
    [self.alarm setHidden:NO];
  }
}

#pragma mark Alarm-Function
- (IBAction)onCbAlarm:(id)sender {
  NSLog(@"CbAlarm : %@", self.txDate.text);
  if (self.txDate.text.length > 0) {
    [self.cbAlarm setBackgroundImage:[UIImage imageNamed:@"checkbox"]
                            forState:UIControlStateNormal];
    self.txDate.text = @"";
    self.txDate.hidden = YES;
    self.alarmDate = nil;
    
    /* Remove notification */
      
  } else {
    /* Pop up AlarmViewController */
    AlarmViewController *alarmVc = [[AlarmViewController alloc] init];
    [alarmVc setQuicknoteVC:self];
    [self presentViewController:alarmVc animated:YES completion:nil];
  }
}

#pragma mark - IBActions
- (IBAction)onDelete:(id)sender {
  if (self.note == nil) {
    [self resetData];
  } else {
    UIAlertView *deleteAlert =
        [[UIAlertView alloc] initWithTitle:@"Sticky Notes"
                                   message:@"Do you want to delete this note?"
                                  delegate:self
                         cancelButtonTitle:@"No"
                         otherButtonTitles:@"Yes", nil];
    [deleteAlert setTag:12345];
    [deleteAlert show];
  }
}

- (IBAction)onCancel:(id)sender {
  if (self.note == nil) {
    [self resetData];
  } else {
    [self.navigationController popViewControllerAnimated:YES];
  }
}

- (IBAction)selectImage:(id)sender {
  _actionSheet.popoverPresentationController.sourceView = self.view;
  _actionSheet.popoverPresentationController.sourceRect =
      CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0);
  [self presentViewController:_actionSheet animated:YES completion:nil];
}

- (IBAction)replaceImage:(id)sender {
  _actionSheet.popoverPresentationController.sourceView = self.view;
  _actionSheet.popoverPresentationController.sourceRect =
      CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0);
  [self presentViewController:_actionSheet animated:YES completion:nil];
}

#pragma mark - <UIAlertViewDelegate>
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (alertView.tag == 12345) {
    switch (buttonIndex) {
      case 0: {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        break;
      }
       
      case 1: {
        [[NoteHelper sharedInstance] deleteNote:_note.objectID];
        [self.navigationController popViewControllerAnimated:YES];
        break;
      }
    }
  }
}

#pragma mark - <ImagePickerHelperDelegate>
- (void)onPicker:(UIImagePickerController *)picker
    didFinishPickingImageWithInfo:(NSDictionary *)info {
  UIImage *importedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
  
  [self.imgNoteImage setImage:importedImage];
  [self.imgNoteImage setNeedsDisplay];
  [self.imgNoteImage layoutIfNeeded];
  self.willResetData = NO;
  
  [picker dismissViewControllerAnimated:YES completion:^{
    [self.btnSelectImage setHidden:YES];
    [self.imgNoteImage setHidden:NO];
    [self.viewImageRefreshView setHidden:NO];
  }];
}

#pragma mark Private-Method
- (void)resetData {
	[_txfTitle setText:@""];
  [_txfTitle resignFirstResponder];
	[self.txvNotingView setText:nil];
	[_txvNotingView.textView setText:@""];
  [_txvNotingView.textView resignFirstResponder];
	[_txvNotingView viewDidLoad];
	[_txvNotingView viewWillAppear:NO];
	[_btnChooseCategory setTitle:@"Select category" forState:UIControlStateNormal];
	_selectedCategory = nil;
	
	[_segment setSelectedSegmentIndex:0];
	[self.customTextView setHidden:NO];
	[_drawingControlView setHidden:YES];
  [_drawingControlView.drawingView setSketchImage:nil];
	[_imagePicker setHidden:YES];
	
	[self.txfTags setText:@""];
    
  // Alarm
  self.alarmDate = nil;
  [self.alarm setHidden:YES];
  self.txDate.hidden = YES;
  [self.cbAlarm setBackgroundImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
  [self.txDate setText:@""];
    
}

- (void)pickerDoneTapped {
  _categoryPickerFrameOriginal = CGRectMake(0,
                                            self.view.frame.size.height,
                                            inputView.frame.size.width,
                                            inputView.frame.size.height);
  [UIView animateWithDuration:0.3 animations:^{
    [inputView setFrame:_categoryPickerFrameOriginal];
  } completion:^(BOOL finished) {
    _pickerViewTogged = NO;
  }];
}

- (void)addEventToViews {
	// For keyboards events
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
	NSDictionary* keyboardInfo = [notification userInfo];
	NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
	CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
	
	if ([self.txfTags isFirstResponder]) {
		[UIView animateWithDuration:0.2 animations:^{
			[self.view setFrame:CGRectMake(0,
										   -keyboardFrameBeginRect.size.height,
										   self.view.frame.size.width,
										   self.view.frame.size.height)];
		}];
    [self.inputView setHidden:YES];
	}
}

- (void)keyboardWillHide:(NSNotification *)notification {
	[UIView animateWithDuration:0.2 animations:^{
		[self.view setFrame:self.viewOriginalFrame];
	}];
  [self.inputView setHidden:NO];
}

@end
