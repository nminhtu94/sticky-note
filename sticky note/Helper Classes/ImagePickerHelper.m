//
//  ImagePickerHelper.m
//  ComparisionAap
//
//  Created by Nguyen minh Tuan on 10/24/14.
//  Copyright (c) 2014 Tanveer Ashraf. All rights reserved.
//

#import "ImagePickerHelper.h"

@implementation ImagePickerHelper
@synthesize delegate;

+ (ImagePickerHelper*)sharedInstance {
	static dispatch_once_t onceToken;
	static ImagePickerHelper* _sharedInstance = nil;
	dispatch_once(&onceToken, ^{
		if (_sharedInstance == nil) {
			_sharedInstance = [[ImagePickerHelper alloc] init];
		}
	});
    return _sharedInstance;
}

- (UIImagePickerController *)pickerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        if ([[ImagePickerHelper sharedInstance] picker] == nil) {
            [ImagePickerHelper sharedInstance].picker =
				[[UIImagePickerController alloc] init];
            [[ImagePickerHelper sharedInstance].picker setDelegate:self];
        }
        
        [[ImagePickerHelper sharedInstance].picker setSourceType:sourceType];
        return self.picker;
    }
    return nil;
}

#pragma mark ImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [[ImagePickerHelper sharedInstance].delegate onPicker:picker
							didFinishPickingImageWithInfo:info];
}
@end
