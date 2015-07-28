//
//  DrawingPadView.h
//  sticky note
//
//  Created by Nguyen Minh Tu on 7/12/15.
//  Copyright (c) 2015 Apps Fellow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawingPadView : UIView

@property (nonatomic, setter=setSketchImage:, getter=sketchImage) UIImage *incrementalImage;

@end
