#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ToDoModel : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSArray *toDoList;
@property (nonatomic, retain) NSArray *doneList;

@end
