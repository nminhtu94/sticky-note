//
//  NoteHelper.h
//  sticky note
//
//  Created by Nguyen Minh Tu on 5/31/15.
//  Copyright (c) 2015 Apps Fellow. All rights reserved.
//

#import "CoreDataCommonHelper.h"
#import "CategoryModel.h"
#import "NoteModel.h"

@interface NoteHelper : CoreDataCommonHelper

+ (NoteHelper *)sharedInstance;

- (BOOL)addNote:(NSString *)title
           text:(NSString *)text
          image:(NSData *)image
         sketch:(NSData *)sketch
           date:(NSDate *)date
       category:(CategoryModel *)category;

- (BOOL)updateNote:(NSManagedObjectID *)objectID
             title:(NSString *)title
              text:(NSString *)text
             image:(NSData *)image
            sketch:(NSData *)sketch
              date:(NSDate *)date
          category:(CategoryModel *)category;

- (NSArray *)getNoteOfCategory:(CategoryModel *)category;

- (BOOL)deleteNote:(NSManagedObjectID *)objectID;

- (NSArray *)searchNote:(NSString *)query;
@end
