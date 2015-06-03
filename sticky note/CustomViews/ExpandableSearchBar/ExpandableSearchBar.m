//
//  ExpandableSearchBar.m
//  ios-app
//
//  Created by Nguyen Minh Tu on 3/13/15.
//  Copyright (c) 2015 Connekt Team. All rights reserved.
//

#import "ExpandableSearchBar.h"

@interface ExpandableSearchBar() {
    BOOL isToggled;
    NSString *_title;
}

@end
@implementation ExpandableSearchBar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"ExpandableSearchBar" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[ExpandableSearchBar class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
        
        [self setFrame:frame];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setup {
    [_txfQuery setDelegate:self];
    [_txfQuery setTintColor:[UIColor blackColor]];
    [_txfQuery setTextColor:[UIColor blackColor]];
    [_txfQuery.layer setBorderWidth:1.0f];
    [_txfQuery.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [_txfQuery.layer setCornerRadius:5.0f];
    [_txfQuery setReturnKeyType:UIReturnKeyDone];
    [_txfQuery setHidden:YES];
    [_txfQuery setBackgroundColor:[UIColor whiteColor]];
    isToggled = NO;
}

- (NSString *)getQuery {
    return _txfQuery.text;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [_lblTitle setText:title];
}

- (NSString *)title {
    return _title;
}

- (void)hideSearchButton {
    [self.btnSearch setHidden:YES];
}


#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.btnSearch isEnabled]) {
        [self searchTapped:_btnSearch];
    } else {
        [self.txfQuery resignFirstResponder];
    }
    return YES;
}
- (IBAction)searchTapped:(id)sender {
    [self toggleWithAnimation:YES completion:nil];
}

- (void)toggleWithAnimation:(BOOL)animation completion:(void (^)())handler {
    
    if (!isToggled) {
        [self.lblTitle setHidden:YES];
        [self layoutIfNeeded];
        self.layoutBtnTrailing.constant = self.frame.size.width - _btnSearch.frame.size.width;
        self.layoutTxfLeading.constant = self.frame.size.height;
        
        if (animation) {
            [UIView animateWithDuration:0.3 animations:^{
                [self layoutIfNeeded];
            } completion:^(BOOL finished) {
                [self.viewQueryHolder bringSubviewToFront:_txfQuery];
                [self.txfQuery setHidden:NO];
                [_txfQuery becomeFirstResponder];
                isToggled = YES;
                
                if (handler) {
                    handler();
                }
            }];
        } else {
            [self layoutIfNeeded];
            [self.viewQueryHolder bringSubviewToFront:_txfQuery];
            [self.txfQuery setHidden:NO];
            [_txfQuery becomeFirstResponder];
            isToggled = YES;
            
            if (handler) {
                handler();
            }
        }
    } else {
        if (![[_txfQuery.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            [_lblTitle setText:_txfQuery.text];
        } else {
            [_lblTitle setText:_title];
        }
        [self.txfQuery setHidden:YES];
        [self layoutIfNeeded];
        self.layoutTxfLeading.constant = 0;
        self.layoutBtnTrailing.constant = 0;
        
        if (animation) {
            [UIView animateWithDuration:0.3 animations:^{
                [self layoutIfNeeded];
            } completion:^(BOOL finished) {
                [_txfQuery resignFirstResponder];
                [self.viewQueryHolder bringSubviewToFront:_lblTitle];
                [self.lblTitle setHidden:NO];
                isToggled = NO;
                
                if (handler) {
                    handler();
                }
            }];
        } else {
            [self layoutIfNeeded];
            [_txfQuery resignFirstResponder];
            [self.viewQueryHolder bringSubviewToFront:_lblTitle];
            [self.lblTitle setHidden:NO];
            isToggled = NO;
            
            if (handler) {
                handler();
            }
        }
    }
}

- (BOOL)isToggled {
    return isToggled;
}
@end
