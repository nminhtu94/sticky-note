#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CategoryModel;

@interface ToDoModel : NSManagedObject

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSArray *toDoList;
@property (nonatomic, retain) CategoryModel *category;

@end
