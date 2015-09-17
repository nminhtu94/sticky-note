#import "CoreDataCommonHelper.h"
#import "CategoryModel.h"

@interface CategoryHelper : CoreDataCommonHelper

+ (CategoryHelper *)sharedInstance;

- (NSArray *)getAllCategory;
- (BOOL)addCategory:(NSString *)name icon:(NSData *)icon;
- (BOOL)updateCategory:(NSManagedObjectID *)objectID name:(NSString *)name icon:(NSData *)data;
- (BOOL)deleteCategory:(NSManagedObjectID *)objectID;

@end
