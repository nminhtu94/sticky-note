//
//  EditCategoryViewController.m
//  sticky note
//
//  Created by Nguyen Minh Tu on 5/31/15.
//  Copyright (c) 2015 Apps Fellow. All rights reserved.
//

#import "EditCategoryViewController.h"

@interface EditCategoryViewController () {
    UIActionSheet *actionSheet;
}

@end

@implementation EditCategoryViewController
@synthesize selectedCategory;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (actionSheet == nil) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Select Photo", nil) delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Camera", nil), NSLocalizedString(@"Photo Library", nil), nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (selectedCategory == nil) {
        [self.viewBottomLayer setHidden:YES];
        [self.btnSelectImage setHidden:NO];
        [self.imgIcon setHidden:YES];
    } else {
        [self.viewBottomLayer setHidden:NO];
        [self.btnSelectImage setHidden:YES];
        [self.imgIcon setHidden:NO];
        [self.imgIcon setImage:[UIImage imageWithData:selectedCategory.icon]];
    }
    
    [[ImagePickerHelper sharedInstance] setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self presentViewController:[[ImagePickerHelper sharedInstance]
                                     pickerWithSourceType:UIImagePickerControllerSourceTypeCamera]
                           animated:YES
                         completion:nil];
    } else if (buttonIndex == 1) {
        [self presentViewController:[[ImagePickerHelper sharedInstance]
                                     pickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary]
                           animated:YES
                         completion:nil];
    }
}

#pragma mark ImagePickerHelperDelegate
- (void)onPicker:(UIImagePickerController *)picker didFinishPickingImageWithInfo:(NSDictionary *)info {
    UIImage *importedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self.imgIcon setImage:importedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.btnSelectImage setHidden:YES];
        [self.viewBottomLayer setHidden:NO];
        [self.imgIcon setHidden:NO];
    }];
    
}

- (IBAction)onSelectImage:(id)sender {
    [actionSheet showInView:self.view];
}

- (IBAction)onReplaceImage:(id)sender {
    [actionSheet showInView:self.view];
}

- (IBAction)onSave:(id)sender {
    if ([self.txfName.text isEqualToString:@""]) {
        return;
    }
    
    if (self.imgIcon.image == nil) {
        return;
    }
    
    if (selectedCategory == nil) {
        [[CategoryHelper sharedInstance] addCategory:self.txfName.text icon:UIImagePNGRepresentation(self.imgIcon.image)];
    } else {
        [[CategoryHelper sharedInstance] updateCategory:selectedCategory.objectID name:self.txfName.text icon:UIImagePNGRepresentation(self.imgIcon.image)];
    }
    
    selectedCategory = nil;
    [self.navigationController popViewControllerAnimated:YES];
}
@end
