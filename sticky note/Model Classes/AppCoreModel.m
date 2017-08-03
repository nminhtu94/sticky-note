//
//  ConnektModel.m
//  ios-app
//
//  Created by Nguyen Minh Tu on 2/1/15.
//  Copyright (c) 2015 Connekt Team. All rights reserved.
//

#import "AppCoreModel.h"

@interface AppCoreModel ()

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (NSURL *)applicationDocumentsDirectory;

@end

@implementation AppCoreModel
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

// Function for accessing the singleton pattern of this class
+(AppCoreModel *) getInstance{
    static AppCoreModel *singletonInstance;
    @synchronized(self){
        // If it is not initialized then initialze it
        if(!singletonInstance){
            singletonInstance = [[AppCoreModel alloc] init];
        }
        return singletonInstance;
    }
}

// Function for deleting and reset the entire database
-(void) deleteDatabase{
    // retrieve the store URL
    NSURL * storeURL = [[self.managedObjectContext persistentStoreCoordinator] URLForPersistentStore:[[[self.managedObjectContext persistentStoreCoordinator] persistentStores] lastObject]];
    // lock the current context
    [[self managedObjectContext] performBlockAndWait:^{
        NSError * error;
        [[self managedObjectContext] reset];//to drop pending changes
        //delete the store from the current managedObjectContext
        if ([[self.managedObjectContext persistentStoreCoordinator] removePersistentStore:[[[self.managedObjectContext persistentStoreCoordinator] persistentStores] lastObject] error:&error])
        {
            // remove the file containing the data
            [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
            
            [NSThread sleepForTimeInterval:0.5];
            //recreate the store like in the  appDelegate method
            [[self.managedObjectContext persistentStoreCoordinator] addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];//recreates the persistent store
            [NSThread sleepForTimeInterval:0.5];
        }
    }];
    
    [[self managedObjectContext] save:nil];
}

#pragma mark -
#pragma mark Core Data stack

/*
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }

    return _managedObjectContext;
//    return self.persistentContainer.viewContext;
}


// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AppCoreDataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


/*
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AppCoreDataModel.sqlite"];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    
    NSPersistentStoreDescription *desc = [[NSPersistentStoreDescription alloc] initWithURL:storeURL];
    desc.type = NSSQLiteStoreType;
    
    NSCoreDataCoreSpotlightDelegate *cdcs =
        [[NSCoreDataCoreSpotlightDelegate alloc] initForStoreWithDescription:desc model:self.managedObjectModel];
    
    // For data migration
    [desc setOption:@YES forKey:NSMigratePersistentStoresAutomaticallyOption];
    [desc setOption:@YES forKey:NSInferMappingModelAutomaticallyOption];
    
    // Spotlight integration
    [desc setOption:cdcs forKey:NSCoreDataCoreSpotlightExporter];
    
    // Persistent History Tracking
    [desc setOption:@YES forKey:NSPersistentHistoryTrackingKey];

    [_persistentStoreCoordinator addPersistentStoreWithDescription:desc completionHandler:^(
        NSPersistentStoreDescription * _Nonnull desc, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Failed to create persistent store");
        }
    }];

    return _persistentStoreCoordinator;
}

#pragma mark -
#pragma mark Application's documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
