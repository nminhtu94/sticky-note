#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;

@interface InAppHelper : NSObject

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);
typedef void (^RequestTransactionsCompletionHandler)(BOOL success, NSArray* transactions);

#pragma mark Custom-Methods
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;
- (void)requestTransactionsWithCompletionHander:(RequestTransactionsCompletionHandler)completionHandler;

- (void)buyProduct:(SKProduct *)product;
- (BOOL)productPurchased:(NSString *)productIdentifier;

@end
