//
//  AlarmViewController.h
//  sticky note
//
//  Created by Le Thanh Tan on 8/23/15.
//  Copyright (c) 2015 Apps Fellow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JTCalendar/JTCalendar.h>

@interface AlarmViewController : UIViewController <JTCalendarDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) UINavigationController *navigationController;

// Tu get here
@property (strong, nonatomic) NSDate *dateSelected;
@property (assign, nonatomic) NSInteger hour;
@property (assign, nonatomic) NSInteger minute;

@end
