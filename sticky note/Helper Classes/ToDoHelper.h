#import "CoreDataCommonHelper.h"

#import "CategoryModel.h"

@interface ToDoHelper : CoreDataCommonHelper

+ (ToDoHelper *)sharedInstance;

- (BOOL)addToDo:(NSString *)title
           date:(NSDate *)date
           list:(NSArray *)todos
       category:(CategoryModel *)category;

- (BOOL)updateToDo:(NSManagedObjectID *)objectID
             title:(NSString *)title
              date:(NSDate *)date
              list:(NSArray *)todos
          category:(CategoryModel *)category;

- (NSArray *)getTodoOfCategory:(CategoryModel *)category;

- (NSArray *)getAllTodo;

- (BOOL)deleteToDo:(NSManagedObjectID *)objectID;

@end
