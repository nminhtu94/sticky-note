#import "NoteInAppHelper.h"

#import "Utility.h"

@implementation NoteInAppHelper

@synthesize product;

+(NoteInAppHelper *)sharedInstance
{
  static NoteInAppHelper *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSSet * productIdentifiers = [NSSet setWithObjects:
                                  ProductBundleID,
                                  nil];
    sharedInstance = [[NoteInAppHelper alloc] initWithProductIdentifiers:productIdentifiers];
    // Do any other initialisation stuff here
  });
  return sharedInstance;
}

- (BOOL)isLiteVersion {
  return ![[NSUserDefaults standardUserDefaults] boolForKey:ProductBundleID];
}

- (void)getProduct:(GetProductCompletionHandler)callback {
  if (product == nil) {
    [self requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
      if (success) {
        if (products.count > 0) {
          product = (SKProduct *)[products objectAtIndex:0];
        }
      }
      if (callback) {
        callback(product);
      }
    }];
  } else {
    if (callback) {
      callback(product);
    }
  }
}

@end
