//
//  MainTabBarViewController.m
//  sticky note
//
//  Created by Nguyen Minh Tu on 7/4/15.
//  Copyright (c) 2015 Apps Fellow. All rights reserved.
//

#import "MainTabBarViewController.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

+(MainTabBarViewController *)sharedInstance
{
    static MainTabBarViewController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MainTabBarViewController alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

-(MainTabBarViewController *)init
{
    if ((self = [super init])) {
        // Init
        UIStoryboard *storyBoard  = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        self = (MainTabBarViewController*)[storyBoard instantiateViewControllerWithIdentifier:@"mainTabBarController"];
    }
    return self;
}

@end
