//
//  Utility.h
//  ios-app
//
//  Created by Nguyen Minh Tu on 2/5/15.
//  Copyright (c) 2015 Connekt Team. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface Utility : NSObject

#define AppUtil         [Utility sharedInstance]

#define THEME_COLOR         [AppUtil colorHex:@"#224348"]
#define THEME_COLOR_LIGHT   [AppUtil colorHex:@"#334D5A"]
#define THEME_COLOR_DARK    [AppUtil colorHex:@"#203B41"]
#define THEME_COLOR_DARKER  [AppUtil colorHex:@"#1C222F"]
#define THEME_ORANGE_COLOR  [AppUtil colorHex:@"#DC654D"]
#define THEME_YELLOW_COLOR  [UIColor colorWithRed:249/255.f green:191/255.f blue:59/255.f alpha:1.0]
#define THEME_RED_COLOR     [AppUtil colorHex:@"#DC664D"]

#define ProductBundleID             @"com.appsfellow.wodWorkout.Premium"

#pragma mark Singleton
+ (Utility *)sharedInstance;

#pragma mark Custom-Methods
- (CGFloat)max:(CGFloat)a :(CGFloat)b ;
- (CGFloat)min:(CGFloat)a :(CGFloat)b ;

- (UIColor *)colorRGBA:(CGFloat)r :(CGFloat)g :(CGFloat)b :(CGFloat)a;// Allow create color with RGB in range 0-255, alpha: 0-1
- (UIColor *)colorHex:(NSString *)hex ; // Allow create color from hex(ex: #FFFFFF, #ABFF00,...)

- (int)randomRange:(int)min :(int)max;

- (UIImage *)takeSnapshot:(UIView *)view; // Take screen shot of a UIView

- (NSDate *)dateFromUTCFormat:(NSString *)dateString;

- (UIAlertView *)showWaitIndicator: (NSString *)title;
- (void)showAlert: (NSString *)title message: (NSString *)message;
@end
