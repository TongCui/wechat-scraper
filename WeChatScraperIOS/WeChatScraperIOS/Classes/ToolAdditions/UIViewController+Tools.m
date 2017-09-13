//
//  UIViewController+Tools.m
//  SimpleMonkey
//
//  Created by tcui on 15/7/15.
//  Copyright (c) 2015 LuckyTR. All rights reserved.
//

#import "UIViewController+Tools.h"
#import <objc/runtime.h>

@implementation UIViewController (Tools)

- (BOOL)monkeyTestDisabled {
    NSNumber *number = objc_getAssociatedObject(self, @"kMT_monkeyTestDisabled");
    return [number boolValue];
}

- (void)setMonkeyTestDisabled:(BOOL)monkeyTestDisabled {
    NSNumber *number = [NSNumber numberWithBool:monkeyTestDisabled];
    objc_setAssociatedObject(self, @"kMT_monkeyTestDisabled", number , OBJC_ASSOCIATION_RETAIN);
}

@end
