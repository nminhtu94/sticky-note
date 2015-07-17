//
//  QuickNoteViewController.m
//  sticky note
//
//  Created by Nguyen Minh Tu on 5/17/15.
//  Copyright (c) 2015 Apps Fellow. All rights reserved.
//

#import "QuickNoteViewController.h"
#import "NoteHelper.h"
#import "CategoryHelper.h"
#import "MainTabBarViewController.h"
//#import "UITextView+ToolBar.h"
//#import "UIViewController+CACategory.h"

@interface QuickNoteViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic) UIPickerView *pickerViewCategory;
@property (nonatomic, assign, getter=isPickerViewTogged) BOOL pickerViewTogged;
@property (nonatomic, assign) CGRect categoryPickerFrameOriginal;
@property (nonatomic, assign) CGRect categoryPickerFrameMoved;
@property (nonatomic) UIAlertView *alertView;

@property (nonatomic) CategoryModel *selectedCategory;

@end

@implementation QuickNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_alertView == nil) {
        _alertView = [[UIAlertView alloc] initWithTitle:@"Sticky Note" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 30)];
    toolbar.barStyle = UIBarStyleDefault;
    [toolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil
                                                                                   action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                             target:self
                                                                             action:@selector(textViewDone:)];
    [barItems addObject:flexibleSpace];
    [barItems addObject:doneBtn];
    [toolbar setItems:barItems animated:YES];
    
    [self.txvNoteText.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.txvNoteText.layer setBorderWidth:1.0f];
    [self.txvNoteText setInputAccessoryView:toolbar];
	
	[_segment setSelectedSegmentIndex:0];
	[_txvNoteText setHidden:NO];
	[_viewDrawingPad setHidden:YES];
    
    _selectedCategory = nil;
}

- (void)textViewDone:(id)sender {
    [self.txvNoteText resignFirstResponder];
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
    [_pickerViewCategory setFrame:_categoryPickerFrameOriginal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UIPickerViewDelegate>
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
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
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
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
    [[NoteHelper sharedInstance] addNote:_txfTitle.text
                                    text:_txvNoteText.text
                                   image:nil
                                  sketch:nil
                                    date:[NSDate date]
                                category:_selectedCategory];
    //[MainTabBar setSelectedIndex:0];
}

- (IBAction)onSelectCategory:(id)sender {
    if ([[CategoryHelper sharedInstance] getAllCategory].count == 0) {
        [_alertView setMessage:@"You don't have any category, please create some"];
        [_alertView show];
        return;
    }
    
    if (!_pickerViewTogged) {
        _categoryPickerFrameMoved = CGRectMake(0,
                                               self.view.frame.size.height - _pickerViewCategory.frame.size.height,
                                               _pickerViewCategory.frame.size.width,
                                               _pickerViewCategory.frame.size.height);
        [UIView animateWithDuration:0.3 animations:^{
            [_pickerViewCategory setFrame:_categoryPickerFrameMoved];
        } completion:^(BOOL finished) {
            _pickerViewTogged = YES;
        }];
    } else {
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
}

- (IBAction)onChangeInputMode:(id)sender {
	UISegmentedControl *selector = (UISegmentedControl *)sender;
	
	if ([selector selectedSegmentIndex] == 0) {
		[_txvNoteText setHidden:NO];
		[_viewDrawingPad setHidden:YES];
	} else {
		[_txvNoteText setHidden:YES];
		[_viewDrawingPad setHidden:NO];
	}
}
@end
