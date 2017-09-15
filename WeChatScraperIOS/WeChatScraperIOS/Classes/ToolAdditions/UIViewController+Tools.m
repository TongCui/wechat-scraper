//
//  UIViewController+Tools.m
//  SimpleMonkey
//
//  Created by tcui on 15/7/15.
//  Copyright (c) 2015 LuckyTR. All rights reserved.
//

#import "UIViewController+Tools.h"
#import <objc/runtime.h>
#import "UIView+Tools.h"
#import "MTAutomationBridge.h"
#import "Global.h"

@implementation UIViewController (Tools)

- (BOOL)monkeyTestDisabled {
    NSNumber *number = objc_getAssociatedObject(self, @"kMT_monkeyTestDisabled");
    return [number boolValue];
}

- (void)setMonkeyTestDisabled:(BOOL)monkeyTestDisabled {
    NSNumber *number = [NSNumber numberWithBool:monkeyTestDisabled];
    objc_setAssociatedObject(self, @"kMT_monkeyTestDisabled", number , OBJC_ASSOCIATION_RETAIN);
}

- (void)tapPoint:(CGPoint)point {
    [MTAutomationBridge tapPoint:point];
}

- (void)tapView:(UIView *)view {
    [MTAutomationBridge tapView:view];
}
- (void)typeInput:(NSString *)input {
    [MTAutomationBridge typeIntoKeyboard:input];
}

- (NSString *)inputClearText {
    NSMutableArray *res = [NSMutableArray array];
    for (NSUInteger i = 0; i < 20; i++) {
        [res addObject:@"\b"];
    }
    
    return [res componentsJoinedByString:@""];
}

- (void)typeClearAndInput:(NSString *)input {
    
    NSString *newInput = [NSString stringWithFormat:@"%@%@", [self inputClearText], input];
    [self typeInput:newInput];
}

- (void)typeClear {
    [self typeInput:[self inputClearText]];
}

- (void)tapCell:(NSInteger)index {
    UIView *cell = [self cellWithIndex:index];
    [MTAutomationBridge tapView:cell];
}

- (void)scrolldownWebView:(NSInteger)offset {
    UIScrollView *webScrollView = [self webViewScrollView];
    CGPoint contentOffset = webScrollView.contentOffset;
    contentOffset.y += offset;
    [webScrollView setContentOffset:contentOffset animated:YES];
}

- (UIScrollView *)webViewScrollView {
    for (UIView *view in self.webView.allSubViews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            return (UIScrollView *)view;
        }
    }
    return nil;
}

- (WKWebView *)webView {
    for (UIView *view in self.view.allSubViews) {
        if ([view isKindOfClass:[WKWebView class]]) {
            return (WKWebView *)view;
        }
    }
    return nil;
}

- (UIView *)cellWithIndex:(NSInteger)index {
    for (UIView *view in self.view.allSubViews) {
        if ([view isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)view;
            NSArray *cells = [tableView visibleCells];
            
            if (index < 0) {
                index = cells.count + index;
            }
            
            return cells[index];
            return view;
        }
    }
    return nil;
}

@end
