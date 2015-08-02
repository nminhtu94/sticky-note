//
//  NotingViewController.m
//  sticky note
//
//  Created by Le Thanh Tan on 8/2/15.
//  Copyright (c) 2015 Apps Fellow. All rights reserved.
//

#import "NotingViewController.h"

@interface NotingViewController ()
{
    NSArray *arrFont;
    NSArray *arrSize;
}

@end

@implementation NotingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    arrFont = [UIFont familyNames];
    arrSize = [[NSArray alloc] initWithObjects:@"9", @"10", @"11", @"12", @"13", @"14", @"18", @"24", @"36", @"48", @"64", @"72", @"96", @"144", @"288", nil];
    
    /* init pickerView */
    self.viewOfPickerView.hidden = YES;
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    
    UIBarButtonItem *pickerViewCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(clickPickerViewCancel)];
    
    UIBarButtonItem *pickerViewSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *pickerViewDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(clickPickerViewDone)];
    [self.toolbar setItems:[[NSArray alloc] initWithObjects:pickerViewCancel, pickerViewSpace, pickerViewDone, nil]];
    [self.toolbar isUserInteractionEnabled];
    
    /* set Font name */
    UIFont *font = self.textView.font;
    NSString *fontName = font.fontName;
    [self.btnFont setTitle:fontName forState:UIControlStateNormal];
    
    /* set Font size */
    [self.btnSize setTitle:[NSString stringWithFormat:@"%0.f", font.pointSize] forState:UIControlStateNormal];
    
    /* set Color */
    [self.btnColor setTitle:@"Color" forState:UIControlStateNormal];
    
    /* set up button Done on right */
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(clickDone)];
    self.navigationItem.rightBarButtonItem = done;
    
}

#pragma mark PickerView
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return [arrFont objectAtIndex:row];
    } else {
        return [arrSize objectAtIndex:row];
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
-(void) clickPickerViewDone{
    self.viewOfPickerView.hidden = YES;
    /* TO-DO something */
    
}

-(void) clickPickerViewCancel{
    self.viewOfPickerView.hidden = YES;
}

#pragma mark
-(void) clickDone{
    NSLog(@"Thanh Tan dep trai qua");
    [self.textView resignFirstResponder];
}

- (IBAction)actionFont:(id)sender {
    self.viewOfPickerView.hidden = NO;
}
- (IBAction)actionSize:(id)sender {
    self.viewOfPickerView.hidden = NO;
}

- (IBAction)actionColor:(id)sender {
}


@end
