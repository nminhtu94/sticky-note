#import "PurchaseViewController.h"

#import "NoteInAppHelper.h"
#import "Utility.h"

@interface PurchaseViewController ()

@end

@implementation PurchaseViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.btnBuy.layer setCornerRadius:5.0f];
  [self.btnRestore.layer setCornerRadius:5.0f];
  
  if ([PurchaseUtil isLiteVersion]) {
    [self.btnBuy setTitle:[NSString stringWithFormat:@"Buy premium for $%0.2f",
                           [PurchaseUtil product].price.doubleValue]
                 forState:UIControlStateNormal];
    [self.btnBuy setEnabled:YES];
    [self.btnRestore setEnabled:YES];
    [self.lblStatus setText:@"You are using sticky note lite"];
  } else {
    [self.btnBuy setEnabled:NO];
    [self.btnRestore setEnabled:NO];
    [self.lblStatus setText:@"You are using sticky note premium"];
  }
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:)
                                               name:IAPHelperProductPurchasedNotification
                                             object:nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)productPurchased:(NSNotification *)notification {
  [AppUtil showAlert:@"Congratulations!"
             message:@"You have purchased Sticky Notes pro, thank you for choosing us"];
}

- (IBAction)buyTapped:(id)sender {
  if ([PurchaseUtil product] != nil) {
    [PurchaseUtil buyProduct:PurchaseUtil.product];
  }
}

- (IBAction)restoreTapped:(id)sender {
  [PurchaseUtil requestTransactionsWithCompletionHander:^(BOOL success, NSArray *transactions) {
    if (success) {
      if ([PurchaseUtil productPurchased:ProductBundleID]) {
        [AppUtil showAlert:@"Restore successful" message:@"Your purchase has been restored!"];
      } else {
        [AppUtil showAlert:@"Error" message:@"No purchases were found for this account"];
      }
    }
  }];
}

- (IBAction)cancelTapped:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}
@end
