//
//  UIViewController+Swizzle.m
//  SimpleMonkey
//
//  Created by tcui on 14/7/15.
//  Copyright (c) 2015 LuckyTR. All rights reserved.
//

#import "UIViewController+Swizzle.h"
#import "UIApplication+Tools.h"
#import "MTVCSense.h"
#import "MTGridWindow.h"

@implementation UIViewController (Swizzle)

- (void)swizzle_viewDidAppear:(BOOL)animated {
    
    if (0 == [self childViewControllers].count && [UIApplication sharedApplication].monkeytestDebug) {
        MTVCSense *sense = [MTVCSense currentSense];
        sense = nil;
    }
    
    [self swizzle_viewDidAppear:animated];
}

- (void)swizzle_viewWillAppear:(BOOL)animated {
    
    [[MTGridWindow sharedInstance] cleanAllMaskViews];
    
    [self swizzle_viewWillAppear:animated];
}

@end
