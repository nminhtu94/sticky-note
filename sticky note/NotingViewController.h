//
//  NotingViewController.h
//  sticky note
//
//  Created by Le Thanh Tan on 8/2/15.
//  Copyright (c) 2015 Apps Fellow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotingViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *btnFont;
@property (weak, nonatomic) IBOutlet UIButton *btnSize;

@property (weak, nonatomic) IBOutlet UIButton *btnColor;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *viewOfPickerView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;


@end
