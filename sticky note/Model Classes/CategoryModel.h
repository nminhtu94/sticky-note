//
//  CategoryModel.h
//  sticky note
//
//  Created by Nguyen Minh Tu on 5/31/15.
//  Copyright (c) 2015 Apps Fellow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NoteModel;

@interface CategoryModel : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * icon;
@property (nonatomic, retain) NSSet *notes;
@end

@interface CategoryModel (CoreDataGeneratedAccessors)

- (void)addNotesObject:(NoteModel *)value;
- (void)removeNotesObject:(NoteModel *)value;
- (void)addNotes:(NSSet *)values;
- (void)removeNotes:(NSSet *)values;

@end
