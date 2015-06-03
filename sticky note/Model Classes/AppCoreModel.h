//
//  ConnektModel.h
//  ios-app
//
//  Created by Nguyen Minh Tu on 2/1/15.
//  Copyright (c) 2015 Connekt Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface AppCoreModel : NSObject
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

+(AppCoreModel *) getInstance;
-(void) deleteDatabase;

@end
