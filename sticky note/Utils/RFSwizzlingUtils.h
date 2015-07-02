//
//  RFSwizzlingUtils.h
//
//  Created by Tu Nguyen on 5/23/13.
//
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface RFSwizzlingUtils : NSObject
/**
 Use swizzle technique to replace our selector at runtime
 */
+ (void) swizzleMethodWithClass: (Class) aClass currentSEL: (SEL) currentSel andReplacedSEL: (SEL) replacedSel;

/**
 Use swizzle technique to replace our implementation of specified selector at runtime
 */
+ (void) swizzleImplementWithDelegateClass: (Class) delegateClass objectClass: (Class) objectClass currentSEL: (SEL) currentSEL replacedSEL: (SEL) replacedSEL andRenameSEL: (SEL) renamedSEL;

@end
