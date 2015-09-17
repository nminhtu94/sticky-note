//
//  AlarmViewController.m
//  sticky note
//
//  Created by Le Thanh Tan on 8/23/15.
//  Copyright (c) 2015 Apps Fellow. All rights reserved.
//

#import "AlarmViewController.h"
#import "QuickNoteViewController.h"

@interface AlarmViewController ()
{
    NSMutableArray *arrHours;
    NSMutableArray *arrSeconds;
}
@end

@implementation AlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // init Hours, Seconds
    arrHours = [[NSMutableArray alloc] init];
    arrSeconds = [[NSMutableArray alloc] init];
    for (int i = 0; i<60; i++) {
        if (i < 24) {
            [arrHours addObject:[NSString stringWithFormat:@"%d", i]];
        }
        [arrSeconds addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    NSDate *date = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: date];
    date = [gregorian dateFromComponents: components];
    NSLog(@"Date: %@", date);
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.dateFormat = @"HH";
    NSString *hourString = [timeFormatter stringFromDate: date];
    self.hour = [hourString intValue];
    
    timeFormatter.dateFormat = @"mm";
    NSString *secondString = [timeFormatter stringFromDate:date];
    self.minute = [secondString intValue];
    self.dateSelected = date;
    
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    [self.pickerView selectRow:(self.hour) inComponent:0 animated:YES];
    [self.pickerView selectRow:(++ self.minute) inComponent:1 animated:YES];
    
    
    // init Calendar
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:date];

    // init scene
    self.title = @"Alarm";
    self.navigationController.toolbarHidden = NO;
    
}

- (IBAction)actionBtnDone:(id)sender {
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: _dateSelected];
    [components setHour:self.hour];
    [components setMinute:self.minute];
    NSDate *resultDate = [gregorian dateFromComponents:components];
    NSLocale* currentLocale = [NSLocale currentLocale];
    [[NSDate date] descriptionWithLocale:currentLocale];

    
    /* To-DO here */
    // return resultDate
    NSArray *viewControllers = self.navigationController.viewControllers;
    QuickNoteViewController *quickNote = (QuickNoteViewController *) [viewControllers objectAtIndex:viewControllers.count - 1];
    
    quickNote.alarmDate = resultDate;
    quickNote.willResetData = NO;
    [quickNote.cbAlarm setBackgroundImage:[UIImage imageNamed:@"checked_checkbox"] forState:UIControlStateNormal];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionBtnCancel:(id)sender {
    /* To-DO here */
    // return resultDate
    QuickNoteViewController *quickNote = [[QuickNoteViewController alloc] initWithNibName:@"QuickNoteViewController" bundle:nil];
    quickNote.alarmDate = nil;
    quickNote.willResetData = NO;
    [quickNote.cbAlarm setBackgroundImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.hidden = NO;

    // Test if the dayView is from another month than the page
    // Use only in month mode for indicate the day of the previous or next month
    if([dayView isFromAnotherMonth]){
        dayView.hidden = YES;
    }
    // Today
    else if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor blueColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }

}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    // Use to indicate the selected date
    _dateSelected = dayView.date;
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];

    // Load the previous or next page if touch a day from another month
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
    // add more one day to _dateSelected
//    _dateSelected = [_dateSelected dateByAddingTimeInterval:60*60*24*1];
}

#pragma mark - <UIPickerViewDelegate>
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        // Hours
        return [arrHours count];
    } else {
        // Second
        return [arrSeconds count];
    }
}

-(void)pickerView:(UIPickerView *)pickerView
     didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component{
    NSLog(@"Row select: %ld",(long)row );
    NSInteger fristRow = [self.pickerView selectedRowInComponent:0];
    NSInteger secondRow = [self.pickerView selectedRowInComponent:1];

    self.hour = [[arrHours objectAtIndex:fristRow] intValue];
    self.minute = [[arrSeconds objectAtIndex:secondRow] intValue];
}

-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component{
    if (component == 0) {
        return [arrHours objectAtIndex:row];
    } else {
        return [arrSeconds objectAtIndex:row];
    }
}

@end
