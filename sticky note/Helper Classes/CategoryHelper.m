#import "CategoryHelper.h"

#import "NoteHelper.h"
#import "ToDoHelper.h"
#import "ToDoModel.h"

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
  CategoryModel *category =
      [NSEntityDescription insertNewObjectForEntityForName:@"CategoryModel"
                                    inManagedObjectContext:[self managedObjectContext]];
  
  [category setName:name];
  [category setIcon:icon];
  
  [self save];
  
  return YES;
}

- (BOOL)updateCategory:(NSManagedObjectID *)objectID name:(NSString *)name icon:(NSData *)data {
  NSError *error = nil;
  CategoryModel *category =
      (CategoryModel*)[[self managedObjectContext] existingObjectWithID:objectID error:&error];
  
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
  CategoryModel *category =
      (CategoryModel*)[[self managedObjectContext] existingObjectWithID:objectID error:&error];
  
  // Remove all notes.
  NSArray *allNotes = [[NoteHelper sharedInstance] getNoteOfCategory:category];
  for (NoteModel *note in allNotes) {
    [[[NoteHelper sharedInstance] managedObjectContext] deleteObject:note];
  }
  
  // Remove all todos.
  NSArray *allTodos = [[ToDoHelper sharedInstance] getTodoOfCategory:category];
  for (ToDoModel *todo in allTodos) {
    [[[ToDoHelper sharedInstance] managedObjectContext] deleteObject:todo];
  }
  
  if (category != nil) {
    [[self managedObjectContext] deleteObject:category];
    return YES;
  }
  
  [self save];
  return NO;
}

- (NSArray *)getAllCategory {
    NSMutableArray *categories = [NSMutableArray new];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CategoryModel"
                                              inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (!error) {
      [categories addObjectsFromArray:results];
    }
    
    return categories;
}

@end
