//
//  EditCategoryViewController.h
//  sticky note
//
//  Created by Nguyen Minh Tu on 5/31/15.
//  Copyright (c) 2015 Apps Fellow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"
#import "CategoryHelper.h"
#import "ImagePickerHelper.h"

@interface EditCategoryViewController : UIViewController <ImagePickerHelperDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) CategoryModel *selectedCategory;

@property (weak, nonatomic) IBOutlet UITextField *txfName;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectImage;
@property (weak, nonatomic) IBOutlet UIView *viewBottomLayer;
@property (weak, nonatomic) IBOutlet UIButton *btnReplaceImage;

- (IBAction)onSelectImage:(id)sender;
- (IBAction)onReplaceImage:(id)sender;
- (IBAction)onSave:(id)sender;

@end
