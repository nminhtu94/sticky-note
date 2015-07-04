//
//  QuickNoteViewController.h
//  sticky note
//
//  Created by Nguyen Minh Tu on 5/17/15.
//  Copyright (c) 2015 Apps Fellow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuickNoteViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *txvNoteText;
@property (weak, nonatomic) IBOutlet UIButton *btnChooseCategory;
@property (weak, nonatomic) IBOutlet UITextField *txfTitle;

- (IBAction)onSaveNote:(id)sender;
- (IBAction)onSelectCategory:(id)sender;

@end
