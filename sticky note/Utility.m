//
//  Utility.m
//  ios-app
//
//  Created by Nguyen Minh Tu on 2/5/15.
//  Copyright (c) 2015 Connekt Team. All rights reserved.
//

#import "Utility.h"

@implementation Utility

#pragma mark Singleton
+(Utility *)sharedInstance
{
    static Utility *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Utility alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

-(Utility *)init
{
    if ((self = [super init])) {
        // Init
    }
    return self;
}

#pragma mark Custom-Methods
- (CGFloat)max: (CGFloat)a :(CGFloat)b {
    return a >= b ? a : b;
}

- (CGFloat)min: (CGFloat)a :(CGFloat)b {
    return a <= b ? a : b;
}

- (UIColor *)colorRGBA:(CGFloat)r :(CGFloat)g :(CGFloat)b :(CGFloat)a{
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a];
}

- (UIColor *)colorHex:(NSString *)hex {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                    green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
                     blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
                           alpha:1.0];
}

- (int)randomRange:(int)min :(int)max {
    if(min == max) return min;
    int randomNumber = min + rand() % (max-min);
    return randomNumber;
}

- (UIImage *)takeSnapshot:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    
    // old style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (NSArray *)parseDataFromString:(NSString *)input {
	NSMutableArray *result = [NSMutableArray new];
	
	if (input != nil && ![input isEqual:[NSNull null]]) {
		NSArray *data = [input componentsSeparatedByString:@","];
		for (NSString *item in data) {
			NSString *trimmedItem =
				[item stringByTrimmingCharactersInSet:
				 	[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			[result addObject:[trimmedItem lowercaseString]];
		}
	}
	return result;
}

- (NSDate *)dateFromUTCFormat:(NSString *)dateString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSLocale* posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.locale = posix;
    
    NSDate *postDate;
    postDate = [dateFormatter dateFromString:dateString];
    
    return postDate;
}

- (UIAlertView *)showWaitIndicator:(NSString *)title {
    UIAlertView *progressAlert;
    progressAlert = [[UIAlertView alloc] initWithTitle:title
                                               message:@"Please wait..."
                                              delegate:nil
                                     cancelButtonTitle:nil
                                     otherButtonTitles:nil];
    [progressAlert show];
    
    UIActivityIndicatorView *activityView;
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.center = CGPointMake(progressAlert.bounds.size.width / 2,
                                      progressAlert.bounds.size.height - 45);
    
    [progressAlert addSubview:activityView];
    [activityView startAnimating];
    return progressAlert;
}

- (NSString *)generateStrings:(NSArray *)input {
	NSString *result = @"";
	
	if (input.count <= 0) {
		return result;
	}
	
	for (NSString *skill in input) {
		result = [result stringByAppendingString:[NSString stringWithFormat:@"%@, ", skill]];
	}
	
	result =
		[result stringByReplacingCharactersInRange:NSMakeRange(result.length - 2, 2)
										withString:@""];
	
	return result;
}

// Helper for showing an alert
- (void)showAlert:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle: title
                                       message: message
                                      delegate: nil
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
    [alert show];
}

@end
