#import "InAppHelper.h"

@interface NoteInAppHelper : InAppHelper

typedef void (^GetProductCompletionHandler)(SKProduct *product);

#define PurchaseUtil        [NoteInAppHelper sharedInstance]

+ (NoteInAppHelper *)sharedInstance;

@property (nonatomic, strong) SKProduct *product;

- (BOOL)isLiteVersion;
- (void)getProduct:(GetProductCompletionHandler)callback;

@end
