#import <UIKit/UIKit.h>

@class CategoryModel;

@interface ToDoCollectionViewController : UIViewController

+ (CategoryModel *)selectedCategory;
+ (void)setSelectedCategory:(CategoryModel *)category;

@property (weak, nonatomic) IBOutlet UIView *todoCollectionHolder;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@end
