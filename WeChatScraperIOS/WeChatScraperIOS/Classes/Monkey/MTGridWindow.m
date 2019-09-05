//
//  MTGridWindow.m
//  TypeTest
//
//  Created by tcui on 12/6/15.
//  Copyright (c) 2015 Tong. All rights reserved.
//

#import "MTGridWindow.h"
#import "Global.h"
#import "MTVCSense.h"
#import "UIView+Tools.h"

@interface MTGridWindow () 

@property (nonatomic, assign) CGFloat mX;
@property (nonatomic, assign) CGFloat mY;

@property (nonatomic, weak) MTVCSense *currentSense;

@end


@implementation MTGridWindow


#pragma mark - Life cycle
+(instancetype)sharedInstance{
    static MTGridWindow *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[MTGridWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
       
    });
    return _sharedInstance;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 1.0f;
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = 1000001.0f;
        self.userInteractionEnabled = NO;
        self.mX = [UIScreen mainScreen].bounds.size.width / WFGrid;
        self.mY = [UIScreen mainScreen].bounds.size.height / WFGrid;
        
    }
    return self;
}

- (void)drawGridWithSense:(MTVCSense *)sense; {
    if (self.gridViewHidden) {
        return;
    }
    self.currentSense = sense;
    
    [self performSelectorOnMainThread:@selector(drawViews) withObject:nil waitUntilDone:YES];
}

- (void)cleanAllMaskViews {
    if (self.gridViewHidden) {
        return;
    }
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subView, NSUInteger idx, BOOL *stop) {
        [subView removeFromSuperview];
    }];
}

- (void)drawViews {
    [self cleanAllMaskViews];

    //  https://developer.apple.com/watch/human-interface-guidelines/ui-elements/
    [self drawOnViews:[self.currentSense.textFields allObjects] withColor:RGBACOLOR(0, 245, 234, 0.13)];
    [self drawOnViews:[self.currentSense.fullScreenWebViews allObjects] withColor:RGBACOLOR(90, 200, 250, 0.15)];
    [self drawOnViews:[self.currentSense.scrollViews allObjects] withColor:RGBACOLOR(32, 148, 250, 0.17)];
    
    [self drawOnViews:[self.currentSense.alertTapableViews allObjects] withColor:RGBACOLOR(250, 17, 79, 0.17)];
    [self drawOnViews:[self.currentSense.preloginTapableViews allObjects] withColor:RGBACOLOR(255, 59, 48, 0.17)];
    [self drawOnViews:[self.currentSense.importantTapableViews allObjects] withColor:RGBACOLOR(255, 149, 0, 0.15)];
    [self drawOnViews:[self.currentSense.tapableViews allObjects] withColor:RGBACOLOR(255, 230, 32, 0.14)];
}

- (void)drawOnViews:(NSArray *)views withColor:(UIColor *)color {
    [views enumerateObjectsUsingBlock:^(UIView *subView, NSUInteger idx, BOOL *stop) {
        [self addMaskWithView:subView color:color];
    }];
}

- (void)addMaskWithView:(UIView *)view color:(UIColor *)color {
    CGRect frame = [view.superview convertRect:view.frame toView:view.window];
    
    UIView *maskView = [[UIView alloc] initWithFrame:frame];
    maskView.userInteractionEnabled = NO;
    maskView.backgroundColor = color;
    [self addSubview:maskView];
}

-(void)updateGrid{
    if (self.gridViewHidden) {
        return;
    }

    [self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:YES];
}

- (UIView *)touchPointViewWithStartPoint:(CGPoint)point {
    
    UIView *clickView = [[UIView alloc] initWithFrame:CGRectMake(fmodf(point.x, [UIScreen mainScreen].bounds.size.width) - 22, fmodf(point.y, [UIScreen mainScreen].bounds.size.height) - 22, 44, 44)];
    clickView.layer.cornerRadius = 22.0f;
    clickView.layer.masksToBounds = YES;
    clickView.alpha = 0.8f;
    clickView.backgroundColor = [UIColor whiteColor];
    
    UIView *clickCenter = [[UIView alloc] initWithFrame:CGRectMake(2.0f, 2.0f, 40.0f, 40.0f)];
    clickCenter.layer.cornerRadius = 20.0f;
    clickCenter.layer.masksToBounds = YES;
    clickCenter.alpha = 0.8f;
    clickCenter.backgroundColor = [UIColor blackColor];
    [clickView addSubview:clickCenter];
    
    return clickView;
}

- (void)showClicked:(CGPoint)point {
    
    UIView *clickView = [self touchPointViewWithStartPoint:point];
    
    [self addSubview:clickView];

    [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        clickView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [clickView removeFromSuperview];
    }];
}

-(void)showMovementFrom:(CGPoint)fromPoint to:(CGPoint)toPoint {
    UIView *clickView = [self touchPointViewWithStartPoint:fromPoint];
    
    [self addSubview:clickView];
    
    [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        clickView.middleX = fmodf(toPoint.x, [UIScreen mainScreen].bounds.size.width);
        clickView.middleY = fmodf(toPoint.y, [UIScreen mainScreen].bounds.size.height);
        clickView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [clickView removeFromSuperview];
    }];
}

@end
