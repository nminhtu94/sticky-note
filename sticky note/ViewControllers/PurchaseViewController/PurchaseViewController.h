#import <UIKit/UIKit.h>

@interface PurchaseViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIButton *btnBuy;
@property (weak, nonatomic) IBOutlet UIButton *btnRestore;

- (IBAction)buyTapped:(id)sender;
- (IBAction)restoreTapped:(id)sender;
- (IBAction)cancelTapped:(id)sender;

@end
