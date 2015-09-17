#import <UIKit/UIKit.h>

@class CategoryModel;

@interface CategorySelectorViewController : UIViewController

+ (CategoryModel *)selectedCategory;
+ (void)setSelectedCategory:(CategoryModel *)category;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

- (IBAction)segmentControlChanged:(id)sender;

@end
