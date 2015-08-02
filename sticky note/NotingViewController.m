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
    NSString *font;
    NSString *size;
}

@end

@implementation NotingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.textView.text = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
    

    
    
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

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"Row select: %ld",(long)row );
    NSInteger fristRow = [self.pickerView selectedRowInComponent:0];
    NSInteger secondRow = [self.pickerView selectedRowInComponent:1];

    font = [arrFont objectAtIndex:fristRow];
    size = [arrSize objectAtIndex:secondRow];
    [self.textView setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@", font] size:[size floatValue]]];
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
    self.pickerView.hidden = YES;
}

- (IBAction)actionFont:(id)sender {
    self.viewOfPickerView.hidden = !self.viewOfPickerView.hidden;
}
- (IBAction)actionSize:(id)sender {
    self.viewOfPickerView.hidden = !self.viewOfPickerView.hidden;
}

- (IBAction)actionColor:(id)sender {
}


@end
