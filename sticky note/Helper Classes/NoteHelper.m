//
//  NoteHelper.m
//  sticky note
//
//  Created by Nguyen Minh Tu on 5/31/15.
//  Copyright (c) 2015 Apps Fellow. All rights reserved.
//

#import "NoteHelper.h"

@interface NoteHelper()

@end

@implementation NoteHelper

+ (NoteHelper *)sharedInstance
{
    static NoteHelper *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NoteHelper alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (NoteHelper *)init
{
    if ((self = [super init])) {
        // Init
    }
    return self;
}

- (BOOL)addNote:(NSString *)title text:(NSString *)text image:(NSData *)image sketch:(NSData *)sketch date:(NSDate *)date category:(CategoryModel *)category {
    
    NoteModel *note = [NSEntityDescription insertNewObjectForEntityForName:@"NoteModel"
                                                    inManagedObjectContext:[self managedObjectContext]];
    [note setTitle:title];
    [note setText:text];
    [note setImage:image];
    [note setSketch:sketch];
    [note setDate:date];
    [note setCategory:category];
    
    [category addNotesObject:note];
    
    [self save];
    return YES;
}

- (BOOL)updateNote:(NSManagedObjectID *)objectID
             title:(NSString *)title
              text:(NSString *)text
             image:(NSData *)image
            sketch:(NSData *)sketch
              date:(NSDate *)date
          category:(CategoryModel *)category {
    
    NSError *error = nil;
    NoteModel *note = (NoteModel*)[[self managedObjectContext] existingObjectWithID:objectID error:&error];
    
    if (note != nil) {
        [note setTitle:title];
        [note setText:text];
        [note setImage:image];
        [note setSketch:sketch];
        [note setDate:date];
        
        if (category.objectID != note.category.objectID) {
            [note.category removeNotesObject:note];
            [note setCategory:category];
            [category addNotesObject:note];
        }
        
        [self save];
        
        return YES;
    }
    
    return NO;
}

- (BOOL)deleteNote:(NSManagedObjectID *)objectID {
    
    NSError *error = nil;
    NoteModel *note = (NoteModel*)[[self managedObjectContext] existingObjectWithID:objectID error:&error];
    
    if (note != nil) {
        [[self managedObjectContext] deleteObject:note];
        return YES;
    }
    return NO;
}

@end
