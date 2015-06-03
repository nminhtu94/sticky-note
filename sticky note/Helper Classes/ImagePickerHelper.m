//
//  ImagePickerHelper.m
//  ComparisionAap
//
//  Created by Nguyen minh Tuan on 10/24/14.
//  Copyright (c) 2014 Tanveer Ashraf. All rights reserved.
//

#import "ImagePickerHelper.h"

static ImagePickerHelper* _sharedInstance;
@implementation ImagePickerHelper
@synthesize delegate;

+ (ImagePickerHelper*)sharedInstance {
    if (_sharedInstance == nil) {
        _sharedInstance = [[ImagePickerHelper alloc] init];
    }
    return _sharedInstance;
}

+ (id) alloc {
    @synchronized([ImagePickerHelper class]){
        NSAssert(_sharedInstance == nil,
                 @"[ImagePickerHelper] Attempted to allocate a second instance of a singleton");
        _sharedInstance = [super alloc];
        return _sharedInstance;
    }
    return nil;
}

- (UIImagePickerController*)pickerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        if (self.picker == nil) {
            self.picker = [[UIImagePickerController alloc] init];
            [self.picker setDelegate:self];
        }
        
        [self.picker setSourceType:sourceType];
        return self.picker;
    }
    return nil;
}

#pragma mark ImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self.delegate onPicker:picker didFinishPickingImageWithInfo:info];
}
@end
