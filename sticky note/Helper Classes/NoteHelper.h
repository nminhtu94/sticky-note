#import "CoreDataCommonHelper.h"
#import "CategoryModel.h"
#import "NoteModel.h"

@interface NoteHelper : CoreDataCommonHelper

+ (NoteHelper *)sharedInstance;

- (BOOL)addNote:(NSString *)title
           text:(NSAttributedString *)text
          image:(NSData *)image
         sketch:(NSData *)sketch
           date:(NSDate *)date
       category:(CategoryModel *)category;

- (BOOL)updateNote:(NSManagedObjectID *)objectID
             title:(NSString *)title
              text:(NSAttributedString *)text
             image:(NSData *)image
            sketch:(NSData *)sketch
              date:(NSDate *)date
          category:(CategoryModel *)category;

- (NSArray *)getNoteOfCategory:(CategoryModel *)category;

- (BOOL)deleteNote:(NSManagedObjectID *)objectID;
@end
