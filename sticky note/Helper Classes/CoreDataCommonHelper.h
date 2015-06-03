//
//  NSObject+CodeDataHelper.h
//  ios-app
//
//  Created by Deepak on 04/02/15.
//  Copyright (c) 2015 Connekt Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataCommonHelper: NSObject
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

// Function for saving the data using private managed object context
-(BOOL) save;

-(void) deleteDatabase;

@end
