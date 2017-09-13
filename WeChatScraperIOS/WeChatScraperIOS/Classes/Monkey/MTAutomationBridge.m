//
//  MTAutomationBridge.m
//  SimpleMonkey
//
//  Created by tcui on 13/7/15.
//  Copyright (c) 2015 LuckyTR. All rights reserved.
//

#import "MTAutomationBridge.h"
#import "Global.h"
#import "KIFTypist.h"
#import "UIView-KIFAdditions.h"
#import "CGGeometry-KIFAdditions.h"
#import "UIView+Tools.h"
#import "MTGridWindow.h"

@interface UIWindow (Private)
+(id)keyWindow;
+(id)_findWithDisplayPoint:(CGPoint)displayPoint;
@end


@implementation MTAutomationBridge

+ (BOOL) typeIntoKeyboard:(NSString *)string userInfo:(id)userInfo {
    DDLog(@"typing into keyboard: %@", string);
    BOOL res = [KIFTypist enterText:string];
    
    if (nil != userInfo) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kMT_keyboardInputDone" object:nil userInfo:userInfo];
    }
    
    return res;
}

+ (BOOL) typeIntoKeyboard:(NSString *)string completionBlock:(void (^)(void))completionBlock {
    DDLog(@"typing into keyboard: %@", string);
    BOOL res = [KIFTypist enterText:string];
    
    if (nil != completionBlock) {
        completionBlock();
    }
    return res;
}


+ (CGPoint) tapPoint:(CGPoint)point {
    
    [[MTGridWindow sharedInstance] showClicked:point];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = [UIWindow _findWithDisplayPoint:point];
        [window tapAtPoint:point];
    });
    
    
    return point;
}

+ (CGPoint) tapView:(UIView *)view {
    if (nil == view) {
        return CGPointZero;
    }
    
    CGPoint point = view.mainWindowPoint;
    [view increaseTapCount];
    
    [[self class] tapPoint:point];
    
    return point;
}


+ (NSArray *) swipeView:(UIView *)view inDirection:(PADirection)dir {
    CGPoint startPoint = CGPointCenteredInRect(view.bounds);
    CGPoint endPoint = startPoint;
    CGFloat distance = 50;
    switch (dir) {
        case PADirectionLeft:
            endPoint = CGPointMake(startPoint.x - distance, startPoint.y);
            break;
        case PADirectionRight:
            endPoint = CGPointMake(startPoint.x + distance, startPoint.y);
            break;
        case PADirectionUp:
            endPoint = CGPointMake(startPoint.x, startPoint.y - distance);
            break;
        case PADirectionDown:
            endPoint = CGPointMake(startPoint.x, startPoint.y + distance);
            break;
            
        default:
            break;
    }
    
    [[MTGridWindow sharedInstance] showMovementFrom:startPoint to:endPoint];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([view isKindOfClass:[UITableView class]]) {
            view.tapped = YES;
        } else if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)view;
            switch (dir) {
                case PADirectionLeft:
                    view.tapped = view.tapped || (scrollView.contentOffset.x + scrollView.width) >= scrollView.contentSize.width;
                    break;
                case PADirectionRight:
                    view.tapped = view.tapped || scrollView.contentOffset.x <= 0;
                    break;
                case PADirectionUp:
                    view.tapped = view.tapped || (scrollView.contentOffset.y + scrollView.height) >= scrollView.contentSize.height;
                    break;
                case PADirectionDown:
                    view.tapped = view.tapped || scrollView.contentOffset.y <= 0;
                    break;
                    
                default:
                    break;
            }
        }
        
        [view dragFromPoint:startPoint toPoint:endPoint steps:5];
    });
    

    return @[[NSValue valueWithCGPoint:startPoint], [NSValue valueWithCGPoint:endPoint]];
}

+ (void)swipeTutorialWithScrollView:(UIScrollView *)scrollView {
    NSUInteger pageNumber = ceilf(scrollView.contentSize.width / scrollView.width);
    
    for (NSUInteger i = 0; i < pageNumber; i++) {
        [[self class] swipeView:scrollView inDirection:PADirectionLeft];
    }
}

+ (void)showPointWithTouch:(UITouch *)touch {

    UIWindow *window = [UIWindow keyWindow];
    CGPoint point = [touch locationInView:window];
    DDLog(@"%@", NSStringFromCGPoint(point));
    [[MTGridWindow sharedInstance] showClicked:point];
}

@end
