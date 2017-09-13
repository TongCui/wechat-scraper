//
//  UIApplication+Swizzle.h
//  SimpleMonkey
//
//  Created by tcui on 20/7/15.
//  Copyright (c) 2015 LuckyTR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (Swizzle)

- (void)swizzle_sendEvent:(UIEvent*)event;

@end
