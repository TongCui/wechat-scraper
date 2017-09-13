//
//  UIView+Tools.h
//  PMP
//
//  Created by Tong on 05/03/2014.
//  Copyright (c) 2014 LuckyTR. All rights reserved.
//

#import <UIKit/UIKit.h>

CGPoint RoundPoint(CGPoint p);
CGSize RoundSize(CGSize s);
CGRect RoundRect(CGRect r);
#define ccr(x, y, w, h) RoundRect(CGRectMake(x, y, w, h))
#define ccp(x, y) RoundPoint(CGPointMake(x, y))
#define ccs(w, h) RoundSize(CGSizeMake(w, h))

@interface UIView (Tools)

@property (nonatomic, readwrite)CGFloat top;
@property (nonatomic, readwrite)CGFloat bottom;
@property (nonatomic, readwrite)CGFloat left;
@property (nonatomic, readwrite)CGFloat right;
@property (nonatomic, readwrite)CGFloat middleX;
@property (nonatomic, readwrite)CGFloat middleY;
@property (nonatomic, readwrite)CGFloat width;
@property (nonatomic, readwrite)CGFloat height;
@property (nonatomic, readonly)CGPoint boundsCenter;
@property (nonatomic, readwrite)CGPoint leftTopPoint;


@property (nonatomic, readonly, getter = isOnWindow) BOOL onWindow;

- (void)removeAllSubviews;

- (void)normalize;
- (void)circlize;

- (void)addBorderLine;
- (void)addBorderLineWithColor:(UIColor *)borderColor;

- (CGSize)quarterSize;

@end


@interface UIView(TViewHiarachy)

@property (nonatomic, readonly, getter = isVisible) BOOL visible;
@property (nonatomic,readonly)UIViewController *viewController;
- (void)showAllSubviews;

- (NSMutableArray*) allSubViews;

@end

@interface UIView(TTouch)

- (void)addTarget:(id)target tapAction:(SEL)action;

@end

@interface UIView(TTMonkeyTest)

//@property (nonatomic, readwrite, assign) CGPoint automationTapPoint;
@property (nonatomic, readwrite, assign) BOOL tapped;
@property (nonatomic, readwrite, assign) NSUInteger tapCount;

- (void)increaseTapCount;

- (CGPoint)mainWindowPoint;
- (CGFloat)ratioOfFrameOccupiedInWindow;

@end






