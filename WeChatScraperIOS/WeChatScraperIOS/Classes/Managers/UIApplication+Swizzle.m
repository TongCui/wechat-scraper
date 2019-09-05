//
//  UIApplication+Swizzle.m
//  SimpleMonkey
//
//  Created by tcui on 20/7/15.
//  Copyright (c) 2015 LuckyTR. All rights reserved.
//

#import "UIApplication+Swizzle.h"
#import "MTAutomationBridge.h"

@implementation UIApplication (Swizzle)

- (void)swizzle_sendEvent:(UIEvent*)event {
    //handle the event (you will probably just reset a timer)
    
    UITouch *touch = [[event allTouches] anyObject];
    
    if (nil != touch && touch.phase == UITouchPhaseBegan) {
        [MTAutomationBridge showPointWithTouch:touch];
    }
    
    [self swizzle_sendEvent:event];
}

@end
