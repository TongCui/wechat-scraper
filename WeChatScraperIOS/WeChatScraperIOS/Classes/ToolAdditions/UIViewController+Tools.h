//
//  UIViewController+Tools.h
//  SimpleMonkey
//
//  Created by tcui on 15/7/15.
//  Copyright (c) 2015 LuckyTR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface UIViewController (Tools)

@property (nonatomic, assign) BOOL monkeyTestDisabled;

- (void)typeClear;
- (void)tapPoint:(CGPoint)point;
- (void)tapView:(UIView *)view;
- (void)typeInput:(NSString *)input;
- (void)typeClearAndInput:(NSString *)input;
- (void)tapCell:(NSInteger)index;
- (void)scrolldownWebView:(NSInteger)offset;
- (UIView *)cellWithIndex:(NSInteger)index;
- (WKWebView *)webView;

@end
