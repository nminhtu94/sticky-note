#import "MainTabBarViewController.h"

#import "Utility.h"
#import "UIImage+ColorImage.h"
#import "ToDoHelper.h"
#import "NoteInAppHelper.h"
#import "CategoryViewController.h"
#import "CategoryNavigationViewController.h"

@interface MainTabBarViewController () <UITabBarControllerDelegate,
                                        UITabBarDelegate,
                                        UIAlertViewDelegate>

@end

static NSString *const storyboardName = @"Main";
static NSString *const tabName = @"mainTabBarController";
static MainTabBarViewController *sharedInstance = nil;

@implementation MainTabBarViewController

+(MainTabBarViewController *)sharedInstance {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
  
    UIStoryboard *storyBoard  = [UIStoryboard storyboardWithName:storyboardName
                                                          bundle:[NSBundle mainBundle]];
    sharedInstance =
        (MainTabBarViewController*)[storyBoard instantiateViewControllerWithIdentifier:tabName];
  });
  return sharedInstance;
}

- (void)viewDidLoad {
	[super viewDidLoad];
  
	// Do any additional setup after loading the view.
	[[UITabBar appearance] setBackgroundImage:[UIImage imageFromColor:THEME_COLOR_DARK
															  forSize:CGSizeMake(self.tabBar.frame.size.width, self.tabBar.frame.size.height)
													 withCornerRadius:0.0f]];
	
	[self.tabBar setTintColor:[UIColor whiteColor]];
	[self.tabBar setSelectionIndicatorImage:[UIImage imageFromColor:THEME_ORANGE_COLOR
															forSize:CGSizeMake(self.tabBar.frame.size.width / 5, self.tabBar.frame.size.height)
												   withCornerRadius:0.0f]];
}

#pragma mark - <UITabBarControllerDelegate>
- (void)tabBarController:(UITabBarController *)tabBarController
    didSelectViewController:(UIViewController *)viewController {
  NSLog(@"Selected VC");
}

#pragma mark - <UITabBarDelegate>
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
  NSUInteger itemIndex = [tabBar.items indexOfObject:item];
  if (itemIndex == 0) {
    CategoryNavigationViewController *shit =
        (CategoryNavigationViewController *)[self.viewControllers objectAtIndex:itemIndex];
    [shit popToRootViewControllerAnimated:NO];
  }
}

@end
