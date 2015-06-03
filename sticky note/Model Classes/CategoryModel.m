//
//  CategoryModel.m
//  sticky note
//
//  Created by Nguyen Minh Tu on 5/31/15.
//  Copyright (c) 2015 Apps Fellow. All rights reserved.
//

#import "CategoryModel.h"
#import "NoteModel.h"


@implementation CategoryModel

@dynamic name;
@dynamic icon;
@dynamic notes;

- (void)addNotesObject:(NoteModel *)value {
    NSMutableSet *set = [NSMutableSet setWithSet:self.notes];
    [set addObject:value];
    self.notes = set;
}

- (void)removeNotesObject:(NoteModel *)value {
    NSMutableSet *set = [NSMutableSet setWithSet:self.notes];
    [set removeObject:value];
    self.notes = set;
}

- (void)addNotes:(NSSet *)values {
    NSMutableSet *set = [NSMutableSet setWithSet:self.notes];
    [set addObjectsFromArray:values.allObjects];
    self.notes = set;
}

- (void)removeNotes:(NSSet *)values {
    NSMutableSet *set = [NSMutableSet setWithSet:self.notes];
    for (NoteModel *note in values) {
        [set removeObject:note];
    }
    self.notes = set;
}

@end
