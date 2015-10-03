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

- (NSArray *)getTodoOfCategory:(CategoryModel *)category {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category = %@", category];
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ToDoModel"];
  [fetchRequest setPredicate:predicate];
  return [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

- (BOOL)deleteToDo:(NSManagedObjectID *)objectID {
	NSError *error = nil;
	ToDoModel *todo =
		(ToDoModel*)[[self managedObjectContext] existingObjectWithID:objectID error:&error];
	
	if (todo != nil) {
		[[self managedObjectContext] deleteObject:todo];
		return YES;
	}
  
  [self save];
	return NO;
}

- (NSArray *)getAllTodo {
  NSMutableArray *todos = [NSMutableArray new];
  
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"ToDoModel"
                                            inManagedObjectContext:[self managedObjectContext]];
  [fetchRequest setEntity:entity];
  
  NSError *error = nil;
  NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
  
  if (!error) {
    [todos addObjectsFromArray:results];
  }
  
  return todos;
}

@end
