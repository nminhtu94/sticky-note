//
//  ExpandableSearchBar.h
//  ios-app
//
//  Created by Nguyen Minh Tu on 3/13/15.
//  Copyright (c) 2015 Connekt Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpandableSearchBar : UIView <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewQueryHolder;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITextField *txfQuery;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutTxfLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutBtnTrailing;

- (IBAction)searchTapped:(id)sender;

- (void)toggleWithAnimation:(BOOL)animation completion:(void(^)())handler;
- (void)hideSearchButton;
- (BOOL)isToggled;

- (NSString *)getQuery;

- (void)setTitle:(NSString *)title;
- (NSString *)title;
@end
