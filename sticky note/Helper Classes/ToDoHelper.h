#import "CoreDataCommonHelper.h"

@interface ToDoHelper : CoreDataCommonHelper

+ (ToDoHelper *)sharedInstance;

- (BOOL)addToDo:(NSString *)title date:(NSDate *)date list:(NSArray *)todos;

- (BOOL)updateToDo:(NSManagedObjectID *)objectID
			 title:(NSString *)title
			  date:(NSDate *)date
			  list:(NSArray *)todos
		  doneList:(NSArray *)doneList;

- (BOOL)checkToDo:(NSManagedObjectID *)objectID item:(NSString *)item;

- (BOOL)uncheckToDo:(NSManagedObjectID *)objectID item:(NSString *)item;

- (BOOL)deleteToDo:(NSManagedObjectID *)objectID;

@end
