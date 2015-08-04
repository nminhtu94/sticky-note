#import "QuickNoteViewController.h"
#import "NoteHelper.h"
#import "CategoryHelper.h"
#import "MainTabBarViewController.h"
#import "DrawingControl.h"
#import "NEOColorPickerViewController.h"
#import "NotingViewController.h"

@interface QuickNoteViewController () <UIPickerViewDelegate,
									   UIPickerViewDataSource,
									   UIActionSheetDelegate,
									   DrawingControlDelegate,
									   NEOColorPickerViewControllerDelegate>

@property (nonatomic) UIPickerView *pickerViewCategory;
@property (nonatomic, assign, getter=isPickerViewTogged) BOOL pickerViewTogged;
@property (nonatomic, assign) CGRect categoryPickerFrameOriginal;
@property (nonatomic, assign) CGRect categoryPickerFrameMoved;
@property (nonatomic) UIAlertView *alertView;
@property (nonatomic) CategoryModel *selectedCategory;
@property (nonatomic) UIActionSheet *actionSheet;
@property (nonatomic, assign) BOOL willResetData;

@property (nonatomic, strong) NotingViewController *txvNotingView;

@end

@implementation QuickNoteViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_alertView == nil) {
        _alertView = [[UIAlertView alloc] initWithTitle:@"Sticky Note"
												message:@""
											   delegate:nil
									  cancelButtonTitle:@"OK"
									  otherButtonTitles:nil, nil];
    }
	
	if (_actionSheet == nil) {
		_actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Select Photo", nil)
												   delegate:self
										  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
									 destructiveButtonTitle:nil
										  otherButtonTitles:NSLocalizedString(@"Camera", nil),
															NSLocalizedString(@"Photo Library",
																			  nil),
						nil];
	}
	self.willResetData = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[self.imagePicker setDelegate:self];
	
	if (self.willResetData) {
		[self resetData];
	}
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_pickerViewCategory == nil) {
        _pickerViewCategory = [[UIPickerView alloc] init];
        
        // Create a category picker view.
        [_pickerViewCategory setDelegate:self];
        [_pickerViewCategory setDataSource:self];
        [self.view addSubview:_pickerViewCategory];
    }
    
    _categoryPickerFrameOriginal = CGRectMake(0,
                                              self.view.frame.size.height,
                                              _pickerViewCategory.frame.size.width,
                                              _pickerViewCategory.frame.size.height);
	
	if (_txvNotingView == nil) {
		_txvNotingView = [[NotingViewController alloc] init];
		[_txvNotingView.view setFrame:self.customTextView.bounds];
	}
	
	[self.drawingControlView.layer setBorderColor:[UIColor blackColor].CGColor];
	[self.drawingControlView.layer setBorderWidth:1.0f];
	[self.drawingControlView setDelegate:self];
	
	if (self.note != nil) {
		[self.segment setSelectedSegmentIndex:0];
		self.willResetData = NO;
		[self.drawingControlView.drawingView setSketchImage:[UIImage imageWithData:self.note.sketch]];
		[self.txvNotingView.textView setAttributedText:self.note.text];
		[self.txvNotingView setText:self.note.text];
		[self.txfTitle setText:self.note.title];
		[self.imagePicker.imageView setImage:[UIImage imageWithData:self.note.image]];
		[self.drawingControlView.drawingView setNeedsDisplay];
	}
	
	[self.customTextView addSubview:_txvNotingView.view];
    [_pickerViewCategory setFrame:_categoryPickerFrameOriginal];
	[self.view layoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UIPickerViewDelegate>
- (void)pickerView:(UIPickerView *)pickerView
	  didSelectRow:(NSInteger)row
	   inComponent:(NSInteger)component {
    NSArray *allCategory = [[CategoryHelper sharedInstance] getAllCategory];
    _selectedCategory = [allCategory objectAtIndex:row];
    
    [_btnChooseCategory setTitle:_selectedCategory.name forState:UIControlStateNormal];
    
    _categoryPickerFrameOriginal = CGRectMake(0,
                                              self.view.frame.size.height,
                                              _pickerViewCategory.frame.size.width,
                                              _pickerViewCategory.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        [_pickerViewCategory setFrame:_categoryPickerFrameOriginal];
    } completion:^(BOOL finished) {
        _pickerViewTogged = NO;
    }];
}

#pragma mark <UIPickerViewDataSource>
- (NSString *)pickerView:(UIPickerView *)pickerView
			 titleForRow:(NSInteger)row
			forComponent:(NSInteger)component {
    NSArray *allCategory = [[CategoryHelper sharedInstance] getAllCategory];
    CategoryModel *category = [allCategory objectAtIndex:row];
    return category.name;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[CategoryHelper sharedInstance] getAllCategory].count;
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		self.willResetData = NO;
		[self presentViewController:[[ImagePickerHelper sharedInstance]
									 pickerWithSourceType:UIImagePickerControllerSourceTypeCamera]
						   animated:YES
						 completion:nil];
	} else if (buttonIndex == 1) {
		[self presentViewController:[[ImagePickerHelper sharedInstance]
			pickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary]
						   animated:YES
						 completion:nil];
		self.willResetData = NO;
	}
}

#pragma mark <ImagePickerViewDelegate>
- (void)imagePickerView:(ImagePickerView *)pickerView onReplaceImage:(id)sender {
	[_actionSheet showInView:self.view];
}

- (void)imagePickerView:(ImagePickerView *)pickerView onSelectImage:(id)sender {
	[_actionSheet showInView:self.view];
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
		[[NoteHelper sharedInstance] addNote:_txfTitle.text
										text:_txvNotingView.textView.attributedText
									   image:UIImagePNGRepresentation([self.imagePicker selectedImage])
									  sketch:UIImagePNGRepresentation(sketch)
										date:[NSDate date]
									category:_selectedCategory];
		self.willResetData = YES;
		[self resetData];
		[MainTabBar setSelectedIndex:0];
	} else {
		[[NoteHelper sharedInstance] updateNote:_note.objectID
										  title:_txfTitle.text
										   text:_txvNotingView.textView.attributedText
										  image:UIImagePNGRepresentation([self.imagePicker selectedImage])
										 sketch:UIImagePNGRepresentation(sketch)
										   date:[NSDate date]
									   category:_selectedCategory];
	}
}

- (IBAction)onSelectCategory:(id)sender {
    if ([[CategoryHelper sharedInstance] getAllCategory].count == 0) {
        [_alertView setMessage:@"You don't have any category, please create some"];
        [_alertView show];
        return;
    }
    
    if (!_pickerViewTogged) {
        _categoryPickerFrameMoved =
			CGRectMake(0,
					   self.view.frame.size.height - _pickerViewCategory.frame.size.height,
					   _pickerViewCategory.frame.size.width,
					   _pickerViewCategory.frame.size.height);
        [UIView animateWithDuration:0.3 animations:^{
            [_pickerViewCategory setFrame:_categoryPickerFrameMoved];
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
            [_pickerViewCategory setFrame:_categoryPickerFrameOriginal];
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
	} else if ([selector selectedSegmentIndex] == 1) {
		[self.customTextView setHidden:YES];
		[_imagePicker setHidden:YES];
		[_drawingControlView setHidden:NO];
	} else if ([selector selectedSegmentIndex] == 2) {
		[self.customTextView setHidden:YES];
		[_imagePicker setHidden:NO];
		[_drawingControlView setHidden:YES];
	}
}

#pragma mark Private-Method
- (void)resetData {
	[_txfTitle setText:@""];
	[_txvNotingView setText:nil];
	[_txvNotingView.textView setText:@""];
	[_txvNotingView viewDidLoad];
	[_txvNotingView viewWillAppear:NO];
	[_btnChooseCategory setTitle:@"Select category" forState:UIControlStateNormal];
	[self.imagePicker reset];
	_selectedCategory = nil;
	
	[_segment setSelectedSegmentIndex:0];
	[self.customTextView setHidden:NO];
	[_drawingControlView setHidden:YES];
	[_imagePicker setHidden:YES];
}

@end
