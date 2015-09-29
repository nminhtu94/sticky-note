#import "EditCategoryViewController.h"
#import "Utility.h"

@interface EditCategoryViewController () {
    UIAlertController *actionSheet;
}

@end

@implementation EditCategoryViewController
@synthesize selectedCategory;

- (void)viewDidLoad {
  [super viewDidLoad];
    
  if (actionSheet == nil) {
    actionSheet = [UIAlertController alertControllerWithTitle:@"Photos"
                                                      message:@"Select your photos source"
                                               preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* library = [UIAlertAction actionWithTitle:@"Library"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action)
    {
      [self presentViewController:[[ImagePickerHelper sharedInstance]
          pickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary]
                         animated:YES
                       completion:nil];
    }];
    UIAlertAction* camera = [UIAlertAction actionWithTitle:@"Camera"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action)
    {
      [self presentViewController:[[ImagePickerHelper sharedInstance]
          pickerWithSourceType:UIImagePickerControllerSourceTypeCamera]
                         animated:YES
                       completion:nil];
    }];
    
    [actionSheet addAction:library];
    [actionSheet addAction:camera];
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
  [self.txfName resignFirstResponder];
  [self.navigationController presentViewController:actionSheet animated:YES completion:nil];
}

- (IBAction)onReplaceImage:(id)sender {
  [self.txfName resignFirstResponder];
  [self.navigationController presentViewController:actionSheet animated:YES completion:nil];
}

- (IBAction)onSave:(id)sender {
  if ([self.txfName.text isEqualToString:@""]) {
    [AppUtil showAlert:@"Sticky Notes" message:@"Please add a category name!"];
    return;
  }
  
  UIImage *categoryImage;
  if (self.imgIcon.image != nil) {
    categoryImage = self.imgIcon.image;
  } else {
    categoryImage = [UIImage imageNamed:@"category"];
  }
  
  if (selectedCategory == nil) {
      [[CategoryHelper sharedInstance] addCategory:self.txfName.text
                                              icon:UIImagePNGRepresentation(categoryImage)];
  } else {
      [[CategoryHelper sharedInstance] updateCategory:selectedCategory.objectID
                                                 name:self.txfName.text
                                                 icon:UIImagePNGRepresentation(categoryImage)];
  }
  
  selectedCategory = nil;
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)backButtonTapped {
	[self.navigationController popViewControllerAnimated:YES];
}

@end
