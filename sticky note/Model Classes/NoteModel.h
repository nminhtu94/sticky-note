//
//  NoteModel.h
//  sticky note
//
//  Created by Nguyen Minh Tu on 5/31/15.
//  Copyright (c) 2015 Apps Fellow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CategoryModel;

@interface NoteModel : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSData * sketch;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) CategoryModel *category;

@end
