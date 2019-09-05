//
//  UIViewController+Swizzle.h
//  SimpleMonkey
//
//  Created by tcui on 14/7/15.
//  Copyright (c) 2015 LuckyTR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Swizzle)

- (void)swizzle_viewDidAppear:(BOOL)animated;

- (void)swizzle_viewWillAppear:(BOOL)animated;

@end
