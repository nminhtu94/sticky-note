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
       category:(CategoryModel *)category
           tags:(NSArray *)tags
          alarm:(NSDate *)alarm;

- (BOOL)updateNote:(NSManagedObjectID *)objectID
             title:(NSString *)title
              text:(NSAttributedString *)text
             image:(NSData *)image
            sketch:(NSData *)sketch
              date:(NSDate *)date
          category:(CategoryModel *)category
              tags:(NSArray *)tags
             alarm:(NSDate *)alarm;

- (NSArray *)getNoteOfCategory:(CategoryModel *)category;

- (NSArray *)getAllNotes;

- (BOOL)deleteNote:(NSManagedObjectID *)objectID;

- (NSArray *)searchNote:(NSString *)query;

- (NSArray *)searchNoteByTag:(NSString *)tag;

@end
