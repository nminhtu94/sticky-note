//
//  CategoryHelper.h
//  sticky note
//
//  Created by Nguyen Minh Tu on 5/31/15.
//  Copyright (c) 2015 Apps Fellow. All rights reserved.
//

#import "CoreDataCommonHelper.h"
#import "CategoryModel.h"

@interface CategoryHelper : CoreDataCommonHelper

+ (CategoryHelper *)sharedInstance;

- (BOOL)addCategory:(NSString *)name icon:(NSData *)icon;
- (BOOL)updateCategory:(NSManagedObjectID *)objectID name:(NSString *)name icon:(NSData *)data;
- (BOOL)deleteCategory:(NSManagedObjectID *)objectID;

@end
