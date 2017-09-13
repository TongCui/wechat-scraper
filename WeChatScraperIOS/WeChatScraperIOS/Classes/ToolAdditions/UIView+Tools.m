//
//  UIView+Tools.m
//  PMP
//
//  Created by Tong on 05/03/2014.
//  Copyright (c) 2014 LuckyTR. All rights reserved.
//

#import "UIView+Tools.h"
#import <QuartzCore/QuartzCore.h>
#import "Global.h"
#import <objc/runtime.h>


CGPoint RoundPoint(CGPoint p) {
    return CGPointMake(roundf(p.x), roundf(p.y));
}

CGSize RoundSize(CGSize s) {
    return CGSizeMake(roundf(s.width), roundf(s.height));
}

CGRect RoundRect(CGRect r) {
    return CGRectMake(roundf(r.origin.x), roundf(r.origin.y), roundf(r.size.width), roundf(r.size.height));
}



#pragma mark - UIView (Attributes)
@implementation UIView (Tools)

- (void)setTop:(CGFloat)t {
    if (self.frame.origin.y != t) {
        self.frame = CGRectMake(self.left, t, self.width, self.height);
    }
}
- (CGFloat)top {
	return self.frame.origin.y;
}
- (void)setBottom:(CGFloat)b {
    if (self.frame.origin.y + self.frame.size.height != b) {
        self.frame = CGRectMake(self.left,b-self.height,self.width,self.height);
    }
}
- (CGFloat)bottom {
	return self.frame.origin.y + self.frame.size.height;
}
- (void)setLeft:(CGFloat)l {
    if (self.frame.origin.x != l) {
        self.frame = CGRectMake(l,self.top,self.width,self.height);
    }
}
- (CGFloat)left {
	return self.frame.origin.x;
}
- (void)setRight:(CGFloat)r {
    if (self.frame.origin.x + self.frame.size.width != r) {
        self.frame = CGRectMake(r-self.width,self.top,self.width,self.height);
    }
}
- (CGFloat)right {
	return self.frame.origin.x + self.frame.size.width;
}
- (void)setMiddleX:(CGFloat)middleX {
    self.frame = CGRectMake(middleX - self.width / 2, self.top, self.width, self.height);
}
- (CGFloat)middleX {
    return self.frame.origin.x + roundf(self.frame.size.width / 2);
}
- (void)setMiddleY:(CGFloat)middleY {
    self.frame = CGRectMake(self.left, middleY - self.height / 2, self.width, self.height);
}
- (CGFloat)middleY {
    return self.frame.origin.y + roundf(self.frame.size.height / 2);
}
- (void)setWidth:(CGFloat)w {
    if (self.frame.size.width != w) {
        self.frame = CGRectMake(self.left, self.top, w, self.height);
    }
}
- (CGFloat)width {
	return self.frame.size.width;
}
- (void)setHeight:(CGFloat)h {
    if (self.frame.size.height != h) {
        self.frame = CGRectMake(self.left, self.top, self.width, h);
    }
}
- (CGFloat)height {
	return self.frame.size.height;
}
- (CGPoint)boundsCenter {
    return CGPointMake(roundf(self.width / 2.0), roundf(self.height / 2.0));
}
- (void)setLeftTopPoint:(CGPoint)leftTopPoint {
    self.frame = CGRectMake(leftTopPoint.x, leftTopPoint.y, self.width, self.height);
}
- (CGPoint)leftTopPoint {
    return CGPointMake(self.frame.origin.x, self.frame.origin.y);
}

- (BOOL)isOnWindow {
    return nil != [self window];
}

- (void)removeAllSubviews {
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
}

- (void)normalize {
    self.layer.cornerRadius = 0;
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.borderWidth = 0;
}

- (void)circlize {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = MIN(self.height, self.width) / 2;
}

- (void)addBorderLine {
    [self addBorderLineWithColor:[UIColor whiteColor]];
}

- (void)addBorderLineWithColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = 2;
}

- (CGSize)quarterSize {
    return CGSizeMake(self.width / 2, self.height / 2);
}

@end





#pragma mark - UIView (ViewHiarachy)
@implementation UIView (TViewHiarachy)

- (BOOL)isVisible {
    return nil != [self window];
}

- (UIViewController*)viewController {
	for (UIView* next = [self superview]; next; next = next.superview) {
		UIResponder* nextResponder = [next nextResponder];
		if ([nextResponder isKindOfClass:[UIViewController class]]) {
			return (UIViewController*)nextResponder;
		}
	}
	return nil;
}

- (void)showAllSubviews {
    [self listSubviewsOfView:self];
}

- (void)listSubviewsOfView:(UIView *)view {
    
    // Get the subviews of the view
    NSArray *subviews = [view subviews];
    
    // Return if there are no subviews
    if ([subviews count] == 0) return; // COUNT CHECK LINE
    
    for (UIView *subview in subviews) {
        
        // Do what you want to do with the subview
        DDLog(@"%@", subview);
        
        // List the subviews of subview
        [self listSubviewsOfView:subview];
    }
}

- (NSMutableArray*)allSubViews {
    NSMutableArray *arr= [NSMutableArray array];
    [arr addObject:self];
    for (UIView *subview in self.subviews) {
        [arr addObjectsFromArray:(NSArray*)[subview allSubViews]];
    }
    return arr;
}

@end

#pragma mark - UIView (Touch)
@implementation UIView (TTouch)

- (void)addTarget:(id)target tapAction:(SEL)action {
    self.userInteractionEnabled = YES;
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:gesture];
}


@end

#pragma mark - UIView (TTMonkeyTest)
@implementation UIView (TTMonkeyTest)

- (CGPoint)mainWindowPoint {
    if (nil == self.superview) {
        return self.center;
    }
    
    if ([self isKindOfClass:[UIWindow class]]) {
        return CGPointMake([UIScreen mainScreen].bounds.size.width  / 2, [UIScreen mainScreen].bounds.size.height / 2);
    }
    
    CGPoint centerPoint = self.center;
    CGPoint tapPointInWindowCoords = [self.superview convertPoint:centerPoint toView:self.window];
    
    return tapPointInWindowCoords;
}

/*
- (CGPoint)automationTapPoint {
    NSValue *value = objc_getAssociatedObject(self, @"kMT_automationTapPoint");
    return [value CGPointValue];
}

- (void)setAutomationTapPoint:(CGPoint)automationTapPoint {
    NSValue *value = [NSValue valueWithCGPoint:automationTapPoint];
    objc_setAssociatedObject(self, @"kMT_automationTapPoint", value , OBJC_ASSOCIATION_RETAIN);
}
 */

- (BOOL)tapped {
    NSNumber *number = objc_getAssociatedObject(self, @"kMT_View_Tapped");
    return [number boolValue];

}

- (void)setTapped:(BOOL)tapped {
    NSNumber *number = [NSNumber numberWithBool:tapped];
    objc_setAssociatedObject(self, @"kMT_View_Tapped", number , OBJC_ASSOCIATION_RETAIN);
}

- (NSUInteger)tapCount {
    NSNumber *number = objc_getAssociatedObject(self, @"kMT_View_TapCount");
    return [number unsignedIntegerValue];
}

- (void)setTapCount:(NSUInteger)tapCount {
    NSNumber *number = [NSNumber numberWithUnsignedInteger:tapCount];
    objc_setAssociatedObject(self, @"kMT_View_TapCount", number , OBJC_ASSOCIATION_RETAIN);
    
    if (tapCount > 2) {
        self.tapped = YES;
    }
}

- (void)increaseTapCount {
    self.tapCount ++;
}

- (CGFloat)ratioOfFrameOccupiedInWindow {
    if (self.window) {
        return self.height * self.height / (self.window.height * self.window.width);
    }
    
    return 0;
}

@end




