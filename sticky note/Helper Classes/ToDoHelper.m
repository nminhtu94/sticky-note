#import "ToDoHelper.h"
#import "ToDoModel.h"

@implementation ToDoHelper

+ (ToDoHelper *)sharedInstance
{
	static ToDoHelper *sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[ToDoHelper alloc] init];
		// Do any other initialisation stuff here
	});
	return sharedInstance;
}

- (ToDoHelper *)init
{
	if ((self = [super init])) {
		// Init
	}
	return self;
}

- (BOOL)addToDo:(NSString *)title
           date:(NSDate *)date
           list:(NSArray *)todos
       category:(CategoryModel *)category {
	ToDoModel *todo =
		[NSEntityDescription insertNewObjectForEntityForName:@"ToDoModel"
									  inManagedObjectContext:[self managedObjectContext]];
	
	[todo setTitle:title];
	[todo setDate:date];
	[todo setToDoList:todos];
  [todo setValue:[self.managedObjectContext objectWithID:[category objectID]]
          forKey:@"category"];
	[self save];
	return YES;
}

- (BOOL)updateToDo:(NSManagedObjectID *)objectID
             title:(NSString *)title
              date:(NSDate *)date
              list:(NSArray *)todos
          category:(CategoryModel *)category {
	NSError *error = nil;
	ToDoModel *todo =
		(ToDoModel*)[[self managedObjectContext] existingObjectWithID:objectID error:&error];
	if (todo != nil) {
		[todo setTitle:title];
		[todo setDate:date];
		[todo setToDoList:todos];
    [todo setValue:[self.managedObjectContext objectWithID:[category objectID]]
            forKey:@"category"];
		[self save];
		return YES;
	}
	return NO;
}

//- (BOOL)checkToDo:(NSManagedObjectID *)objectID item:(NSString *)item {
//	NSError *error = nil;
//	ToDoModel *todo =
//		(ToDoModel*)[[self managedObjectContext] existingObjectWithID:objectID error:&error];
//	
//	if (todo != nil) {
//		NSArray *doList = [todo toDoList];
//		NSMutableArray *doneList = [NSMutableArray arrayWithArray:[todo doneList]];
//		for (NSString *string in doList) {
//			if ([string isEqualToString:item]) {
//				[doneList addObject:string];
//			}
//		}
//		
//		[todo setDoneList:doneList];
//		[self save];
//		return YES;
//	}
//	return NO;
//}

- (NSArray *)getTodoOfCategory:(CategoryModel *)category {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category = %@", category];
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ToDoModel"];
  [fetchRequest setPredicate:predicate];
  return [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

//- (BOOL)uncheckToDo:(NSManagedObjectID *)objectID item:(NSString *)item {
//	NSError *error = nil;
//	ToDoModel *todo =
//		(ToDoModel*)[[self managedObjectContext] existingObjectWithID:objectID error:&error];
//	
//	if (todo != nil) {
//		NSMutableArray *doneList = [NSMutableArray arrayWithArray:[todo doneList]];
//		for (NSString *string in doneList) {
//			if ([string isEqualToString:item]) {
//				[doneList removeObject:string];
//			}
//		}
//		[todo setDoneList:doneList];
//		[self save];
//		return YES;
//	}
//	return NO;
//}

- (BOOL)deleteToDo:(NSManagedObjectID *)objectID {
	NSError *error = nil;
	ToDoModel *todo =
		(ToDoModel*)[[self managedObjectContext] existingObjectWithID:objectID error:&error];
	
	if (todo != nil) {
		[[self managedObjectContext] deleteObject:todo];
		return YES;
	}
	return NO;
}

@end
