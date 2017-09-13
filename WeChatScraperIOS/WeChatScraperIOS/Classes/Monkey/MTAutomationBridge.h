//
//  MTAutomationBridge.h
//  SimpleMonkey
//
//  Created by tcui on 13/7/15.
//  Copyright (c) 2015 LuckyTR. All rights reserved.
//

#import "UIAutomationBridge.h"



@interface MTAutomationBridge : UIAutomationBridge

+ (BOOL) typeIntoKeyboard:(NSString *)string userInfo:(id)userInfo;
+ (BOOL) typeIntoKeyboard:(NSString *)string completionBlock:(void (^)(void))completionBlock;

+ (CGPoint) tapPoint:(CGPoint)point;
+ (CGPoint) tapView:(UIView *)view;

+ (NSArray *) swipeView:(UIView *)view inDirection:(PADirection)dir;
+ (void)swipeTutorialWithScrollView:(UIScrollView *)scrollView;

+ (void)showPointWithTouch:(UITouch *)touch;


@end
