//
//  CategoryHelper.m
//  sticky note
//
//  Created by Nguyen Minh Tu on 5/31/15.
//  Copyright (c) 2015 Apps Fellow. All rights reserved.
//

#import "CategoryHelper.h"

@implementation CategoryHelper

+ (CategoryHelper *)sharedInstance {
    static CategoryHelper *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CategoryHelper alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (CategoryHelper *)init {
    if ((self = [super init])) {
        // Init
    }
    return self;
}

- (BOOL)addCategory:(NSString *)name icon:(NSData *)icon {
    
    CategoryModel *category = [NSEntityDescription insertNewObjectForEntityForName:@"CategoryModel"
                                                            inManagedObjectContext:[self managedObjectContext]];
    
    [category setName:name];
    [category setIcon:icon];
    
    [self save];
    
    return YES;
}

- (BOOL)updateCategory:(NSManagedObjectID *)objectID name:(NSString *)name icon:(NSData *)data {
    NSError *error = nil;
    CategoryModel *category = (CategoryModel*)[[self managedObjectContext] existingObjectWithID:objectID error:&error];
    
    if (category != nil) {
        
        [category setName:name];
        [category setIcon:data];
        
        [self save];
        
        return YES;
    }
    
    return NO;
}

- (BOOL)deleteCategory:(NSManagedObjectID *)objectID {
    
    NSError *error = nil;
    CategoryModel *category = (CategoryModel*)[[self managedObjectContext] existingObjectWithID:objectID error:&error];
    
    if (category != nil) {
        [[self managedObjectContext] deleteObject:category];
        return YES;
    }
    
    return NO;
}

@end
