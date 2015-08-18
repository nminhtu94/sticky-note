#import "MainTabBarViewController.h"
#import "Utility.h"
#import "UIImage+ColorImage.h"

@interface MainTabBarViewController ()

@end

static NSString *storyboardName = @"Main";
static NSString *tabName = @"mainTabBarController";

@implementation MainTabBarViewController

+(MainTabBarViewController *)sharedInstance
{
    static MainTabBarViewController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // sharedInstance = [[MainTabBarViewController alloc] init];
        // Do any other initialisation stuff here
		UIStoryboard *storyBoard  = [UIStoryboard storyboardWithName:storyboardName
															  bundle:[NSBundle mainBundle]];
		sharedInstance =
			(MainTabBarViewController*)[storyBoard instantiateViewControllerWithIdentifier:tabName];
    });
    return sharedInstance;
}

-(MainTabBarViewController *)init
{
    if ((self = [super init])) {
        // Init
        UIStoryboard *storyBoard  = [UIStoryboard storyboardWithName:storyboardName
															  bundle:[NSBundle mainBundle]];
        self =
			(MainTabBarViewController*)[storyBoard instantiateViewControllerWithIdentifier:tabName];
    }
    return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	[[UITabBar appearance] setBackgroundImage:[UIImage imageFromColor:THEME_COLOR_DARK
															  forSize:CGSizeMake(self.tabBar.frame.size.width, self.tabBar.frame.size.height)
													 withCornerRadius:0.0f]];
	
	[self.tabBar setSelectedImageTintColor:[UIColor whiteColor]];
	[self.tabBar setSelectionIndicatorImage:[UIImage imageFromColor:THEME_ORANGE_COLOR
															forSize:CGSizeMake(self.tabBar.frame.size.width / 5, self.tabBar.frame.size.height)
												   withCornerRadius:0.0f]];
}

@end
