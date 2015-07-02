//
//  RFSwizzlingUtils.m
//
//  Created by Tu Nguyen on 5/23/13.
//
//

#import "RFSwizzlingUtils.h"

@implementation RFSwizzlingUtils
+ (void) swizzleMethodWithClass: (Class) aClass currentSEL: (SEL) currentSel andReplacedSEL: (SEL) replacedSel {
    
    Method currentMethod = class_getInstanceMethod(aClass, currentSel);
    Method replacedMethod = class_getInstanceMethod(aClass, replacedSel);
    method_exchangeImplementations(currentMethod, replacedMethod);
}

+ (void) swizzleImplementWithDelegateClass: (Class) delegateClass objectClass: (Class) objectClass currentSEL: (SEL) currentSEL replacedSEL: (SEL) replacedSEL andRenameSEL: (SEL) renamedSEL {
    
    Method currentMethod = class_getInstanceMethod(delegateClass, currentSEL);
    if (currentMethod) {
        IMP currentImplement = method_getImplementation(currentMethod);
        Method replacedMethod = class_getInstanceMethod(objectClass, replacedSEL);
        IMP replacedImplement = method_getImplementation(replacedMethod);
        
        if (currentImplement != replacedImplement) {
            method_setImplementation(currentMethod, replacedImplement);
            class_addMethod(delegateClass, renamedSEL, currentImplement, "v@:@i@");
        }
    }
}

@end
