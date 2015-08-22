#import "EditCategoryViewController.h"
#import "Utility.h"

@interface EditCategoryViewController () {
    UIActionSheet *actionSheet;
}

@end

@implementation EditCategoryViewController
@synthesize selectedCategory;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (actionSheet == nil) {
        actionSheet =
			[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Select Photo", nil)
										delegate:self
							   cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
						  destructiveButtonTitle:nil
							   otherButtonTitles:NSLocalizedString(@"Camera", nil),
			 									 NSLocalizedString(@"Photo Library", nil), nil];
    }
	
	[self.view setBackgroundColor:THEME_COLOR_DARKER];
	
	// this will appear as the title in the navigation bar
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:20.0];
	label.textAlignment = NSTextAlignmentCenter;
	// ^-Use UITextAlignmentCenter for older SDKs.
	label.textColor = [UIColor whiteColor]; // change this color
	self.navigationItem.titleView = label;
	label.text = NSLocalizedString(@"Edit Category", @"");
	[label sizeToFit];
	
	UIBarButtonItem *backButton =
	[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
												  target:self
												  action:@selector(backButtonTapped)];
	[backButton setTintColor:[UIColor whiteColor]];
	[self.navigationItem setLeftBarButtonItem:backButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (selectedCategory == nil) {
        [self.viewBottomLayer setHidden:YES];
        [self.btnSelectImage setHidden:NO];
        [self.imgIcon setHidden:YES];
    } else {
        [self.viewBottomLayer setHidden:NO];
        [self.btnSelectImage setHidden:YES];
        [self.imgIcon setHidden:NO];
        [self.imgIcon setImage:[UIImage imageWithData:selectedCategory.icon]];
    }
    
    [[ImagePickerHelper sharedInstance] setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self presentViewController:
		 	[[ImagePickerHelper sharedInstance]
			 	pickerWithSourceType:UIImagePickerControllerSourceTypeCamera]
                           animated:YES
                         completion:nil];
    } else if (buttonIndex == 1) {
        [self presentViewController:
		 	[[ImagePickerHelper sharedInstance]
			 	pickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary]
                           animated:YES
                         completion:nil];
    }
}

#pragma mark ImagePickerHelperDelegate
- (void)onPicker:(UIImagePickerController *)picker
	didFinishPickingImageWithInfo:(NSDictionary *)info {
    UIImage *importedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self.imgIcon setImage:importedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.btnSelectImage setHidden:YES];
        [self.viewBottomLayer setHidden:NO];
        [self.imgIcon setHidden:NO];
    }];
    
}

- (IBAction)onSelectImage:(id)sender {
    [actionSheet showInView:self.view];
}

- (IBAction)onReplaceImage:(id)sender {
    [actionSheet showInView:self.view];
}

- (IBAction)onSave:(id)sender {
    if ([self.txfName.text isEqualToString:@""]) {
        return;
    }
    
    if (self.imgIcon.image == nil) {
        return;
    }
    
    if (selectedCategory == nil) {
        [[CategoryHelper sharedInstance] addCategory:self.txfName.text
												icon:UIImagePNGRepresentation(self.imgIcon.image)];
    } else {
        [[CategoryHelper sharedInstance] updateCategory:selectedCategory.objectID
												   name:self.txfName.text
												   icon:UIImagePNGRepresentation(self.imgIcon.image)];
    }
    
    selectedCategory = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backButtonTapped {
	[self.navigationController popViewControllerAnimated:YES];
}

@end
