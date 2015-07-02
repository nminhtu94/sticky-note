//
//  UIViewController+CACategory.m
//  ComparisionAap
//
//  Created by Nguyen minh Tuan on 10/3/14.
//  Copyright (c) 2014 Tanveer Ashraf. All rights reserved.
//

#import "UIViewController+CACategory.h"
#import "RFSwizzlingUtils.h"

static NSArray* recordedClass;

@implementation UIViewController(CACategory)

+ (void)load {
    if (self == [UIViewController class]) {
        [RFSwizzlingUtils swizzleMethodWithClass:self currentSEL:@selector(viewDidAppear:) andReplacedSEL:@selector(caViewDidAppear:)];
        [RFSwizzlingUtils swizzleMethodWithClass:self currentSEL:@selector(viewWillAppear:) andReplacedSEL:@selector(caViewWillAppear:)];
        [RFSwizzlingUtils swizzleMethodWithClass:self currentSEL:@selector(viewDidLoad) andReplacedSEL:@selector(caViewDidLoad)];
    }
}

- (void)caViewDidAppear:(BOOL)animated {
    [self caViewDidAppear:animated];
//    // For keyboards events
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:)  name:UIKeyboardDidHideNotification object:nil];
}

- (void)caViewWillAppear:(BOOL)animated {
    [self caViewWillAppear:animated];
}

- (void)caViewDidLoad {
    [self caViewDidLoad];
}

#pragma mark Keyboard-Events
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view setFrame:CGRectMake(0,
                                       -keyboardFrameBeginRect.size.height/2,
                                       self.view.frame.size.width,
                                       self.view.frame.size.height)];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.2 animations:^{
        [self.view setFrame:CGRectMake(0,
                                       0,
                                       self.view.frame.size.width,
                                       self.view.frame.size.height)];
    }];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    
}

@end
