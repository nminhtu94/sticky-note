#import "NoteHelper.h"

@interface NoteHelper()

@end

@implementation NoteHelper

+ (NoteHelper *)sharedInstance
{
    static NoteHelper *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NoteHelper alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (NoteHelper *)init
{
    if ((self = [super init])) {
        // Init
    }
    return self;
}

- (BOOL)addNote:(NSString *)title
		   text:(NSAttributedString *)text
		  image:(NSData *)image
		 sketch:(NSData *)sketch
		   date:(NSDate *)date
	   category:(CategoryModel *)category
		   tags:(NSArray *)tags {
	
    NoteModel *note =
		[NSEntityDescription insertNewObjectForEntityForName:@"NoteModel"
									  inManagedObjectContext:[self managedObjectContext]];
    [note setTitle:title];
    [note setText:text];
    [note setImage:image];
    [note setSketch:sketch];
    [note setDate:date];
    [note setValue:[self.managedObjectContext objectWithID:[category objectID]]
			forKey:@"category"];
	[note setTags:tags];
    [self save];
    return YES;
}

- (BOOL)updateNote:(NSManagedObjectID *)objectID
			 title:(NSString *)title
			  text:(NSAttributedString *)text
			 image:(NSData *)image
			sketch:(NSData *)sketch
			  date:(NSDate *)date
		  category:(CategoryModel *)category
			  tags:(NSArray *)tags {
	
    NSError *error = nil;
    NoteModel *note =
		(NoteModel*)[[self managedObjectContext] existingObjectWithID:objectID error:&error];
    
    if (note != nil) {
        [note setTitle:title];
        [note setText:text];
        [note setImage:image];
        [note setSketch:sketch];
        [note setDate:date];
		[note setTags:tags];
        
        if (category.objectID != note.category.objectID) {
            [note.category removeNotesObject:note];
            [note setCategory:category];
            [category addNotesObject:note];
        }
        
        [self save];
        
        return YES;
    }
    
    return NO;
}

- (NSArray *)getNoteOfCategory:(CategoryModel *)category {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category = %@", category];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"NoteModel"];
    [fetchRequest setPredicate:predicate];
    
    return [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

- (BOOL)deleteNote:(NSManagedObjectID *)objectID {
    
    NSError *error = nil;
    NoteModel *note =
		(NoteModel*)[[self managedObjectContext] existingObjectWithID:objectID error:&error];
    
    if (note != nil) {
        [[self managedObjectContext] deleteObject:note];
        return YES;
    }
    return NO;
}

- (NSArray *)searchNote:(NSString *)query{
    NSArray *result = [[NSArray alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(title CONTAINS[cd] %@) OR (text CONTAINS[cd] %@)", query, query];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"NoteModel"];
    [fetchRequest setPredicate:predicate];
    
    result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    // FILTER AFTER SHOW RESULT
    return result;
}

@end
