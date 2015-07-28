//
//  ImagePickerHelper.h
//  ComparisionAap
//
//  Created by Nguyen minh Tuan on 10/24/14.
//  Copyright (c) 2014 Tanveer Ashraf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ImagePickerHelper;
@protocol ImagePickerHelperDelegate

- (void)onPicker: (UIImagePickerController*)picker
	didFinishPickingImageWithInfo:(NSDictionary*)info;

@end

@interface ImagePickerHelper : NSObject <UINavigationControllerDelegate,
										 UIImagePickerControllerDelegate>

@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) UIImagePickerController* picker;

- (UIImagePickerController*)pickerWithSourceType: (UIImagePickerControllerSourceType)sourceType;
+ (ImagePickerHelper*)sharedInstance;

@end
