#import <UIKit/UIKit.h>

@class CategoryModel;

@interface NoteViewController : UIViewController

+ (CategoryModel *)selectedCategory;
+ (void)setSelectedCategory:(CategoryModel *)category;

@property (weak, nonatomic) IBOutlet UIView *viewNoteCollectionHolder;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;

@end
