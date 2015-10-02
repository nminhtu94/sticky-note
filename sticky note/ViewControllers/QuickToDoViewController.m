#import "QuickToDoViewController.h"

#import "TodoTableView.h"
#import "ToDoHelper.h"
#import "ToDoModel.h"
#import "CategoryModel.h"
#import "Utility.h"
#import "CategoryHelper.h"
#import "NoteInAppHelper.h"
#import "PurchaseViewController.h"

@interface QuickToDoViewController () <UIPickerViewDataSource,
                                       UIPickerViewDelegate,
                                       UITextFieldDelegate,
                                       UIAlertViewDelegate>

@property (nonatomic, strong) TodoTableView *todoTable;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic) CategoryModel *selectedCategory;
@property (nonatomic) UIPickerView *pickerViewCategory;
@property (nonatomic, assign) CGRect categoryPickerFrameOriginal;
@property (nonatomic, assign) CGRect categoryPickerFrameMoved;
@property (nonatomic, assign, getter=isPickerViewTogged) BOOL pickerViewTogged;
@property (nonatomic) UIAlertView *alertView;
@property (nonatomic, assign) BOOL willResetData;
@property (nonatomic, strong) PurchaseViewController *purchseVC;

@property (nonatomic) UIView *inputView;

@end

@implementation QuickToDoViewController
@synthesize inputView;

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
  
  if (self.purchseVC == nil) {
    self.purchseVC = [[PurchaseViewController alloc] init];
  }
  
  [self.txfTitle setReturnKeyType:UIReturnKeyDone];
  [self.txfTitle setDelegate:self];
  self.willResetData = YES;
  
  // this will appear as the title in the navigation bar
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
  label.backgroundColor = [UIColor clearColor];
  label.font = [UIFont boldSystemFontOfSize:20.0];
  label.textAlignment = NSTextAlignmentCenter;
  // ^-Use UITextAlignmentCenter for older SDKs.
  label.textColor = [UIColor whiteColor]; // change this color
  self.navigationItem.titleView = label;
  label.text = NSLocalizedString(@"To-Do", @"");
  [label sizeToFit];
  
  [self.navigationController.navigationBar setTranslucent:NO];
  [self.navigationController.navigationBar setBarTintColor:THEME_COLOR];
  [[UIApplication sharedApplication] setStatusBarHidden:NO];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
  
  if (self.willResetData) {
    [self resetData];
  }
  [self.view setBackgroundColor:THEME_COLOR_DARKER];
  
  [self.txfTitle setBackgroundColor:THEME_COLOR_DARKER];
  [self.txfTitle setTextColor:[UIColor whiteColor]];
  [self.txfTitle.layer setBorderWidth:3.0f];
  [self.txfTitle.layer setBorderColor:[UIColor whiteColor].CGColor];
  [self.txfTitle setClipsToBounds:YES];
  
  [self.btnCategory.layer setCornerRadius:5.0f];
  [self.btnCategory setClipsToBounds:YES];
  
  [self.viewTodoTable setBackgroundColor:[UIColor clearColor]];
  [self.controlView setBackgroundColor:[UIColor clearColor]];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if (self.todoTable == nil) {
		self.todoTable = [[TodoTableView alloc] initWithFrame:self.viewTodoTable.bounds];
    [self.todoTable setBackgroundColor:[UIColor clearColor]];
		[self.viewTodoTable addSubview:self.todoTable];
	}
	
	if (self.todoItem == nil) {
		self.todoTable.data = [NSMutableArray array];
  } else {
    self.todoTable.data = [NSMutableArray arrayWithArray:self.todoItem.toDoList];
    [self.txfTitle setText:self.todoItem.title];
    self.willResetData = NO;
  }
  
  if (inputView == nil) {
    [self createInputView];
  }
  
  _categoryPickerFrameOriginal = CGRectMake(0,
                                            self.view.frame.size.height,
                                            inputView.frame.size.width,
                                            inputView.frame.size.height);
  [inputView setFrame:_categoryPickerFrameOriginal];
  [_pickerViewCategory reloadAllComponents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark <UIPickerViewDelegate>
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
  if (row == 0) {
    return;
  }
  NSArray *allCategory = [[CategoryHelper sharedInstance] getAllCategory];
  _selectedCategory = [allCategory objectAtIndex:row - 1];
  [self.btnCategory setTitle:_selectedCategory.name forState:UIControlStateNormal];
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

#pragma mark - <UIAlertViewDelegate>
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  switch (buttonIndex) {
    case 0: {
      [alertView dismissWithClickedButtonIndex:0 animated:YES];
      break;
    }
      
    case 1: {
      [self presentViewController:self.purchseVC animated:YES completion:nil];
      break;
    }
  }
}

- (IBAction)onAddItem:(id)sender {
	[self.todoTable insertRowAtEnd];
}

- (IBAction)onSave:(id)sender {
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
  
  if (self.todoItem == nil) {
    if (![self checkPremium]) {
      return;
    }
    [[ToDoHelper sharedInstance] addToDo:self.txfTitle.text
                                    date:[NSDate date]
                                    list:self.todoTable.data
                                category:self.selectedCategory];
    [self resetData];
  } else {
    [[ToDoHelper sharedInstance] updateToDo:self.todoItem.objectID
                                      title:self.txfTitle.text
                                       date:[NSDate date]
                                       list:self.todoTable.data
                                   category:self.selectedCategory];
    [self.navigationController popViewControllerAnimated:YES];
  }
  
  [AppUtil showAlert:@"Sticky Notes" message:@"Todo saved successfully"];
  [self resignFirstResponder];
}

- (BOOL)checkPremium {
  if ([[ToDoHelper sharedInstance] getAllTodo].count == 2 && [PurchaseUtil isLiteVersion]) {
    UIAlertView *alertView =
    [[UIAlertView alloc] initWithTitle:@"Sticky Note"
                               message:@""
                              delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@"Upgrade", nil];
    [alertView setDelegate:self];
    [alertView setMessage:@"You cannot create more than 2 todos in lite version. Please upgrade to premium"];
    [alertView show];
    return NO;
  }
  
  return YES;
}

- (IBAction)onCancel:(id)sender {
  if (self.willResetData) {
    [self resetData];
  } else {
    [self.navigationController popViewControllerAnimated:YES];
  }
}

- (IBAction)selectCategoryTapped:(id)sender {
  if ([[CategoryHelper sharedInstance] getAllCategory].count == 0) {
    [_alertView setMessage:@"You don't have any category, please create some"];
    [_alertView show];
    return;
  }
  
  if (!_pickerViewTogged) {
    _categoryPickerFrameMoved =
    CGRectMake(0,
               self.view.frame.size.height - inputView.frame.size.height,
               inputView.frame.size.width,
               inputView.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
      [inputView setFrame:_categoryPickerFrameMoved];
    } completion:^(BOOL finished) {
      _pickerViewTogged = YES;
    }];
  } else {
    _categoryPickerFrameOriginal =
    CGRectMake(0,
               self.view.frame.size.height,
               inputView.frame.size.width,
               inputView.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
      [inputView setFrame:_categoryPickerFrameOriginal];
    } completion:^(BOOL finished) {
      _pickerViewTogged = NO;
    }];
  }
}


#pragma mark - Private Methods
- (void)resetData {
  [self.txfTitle setText:@""];
  [self.todoTable.data removeAllObjects];
  [self.todoTable reloadData];
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

@end
