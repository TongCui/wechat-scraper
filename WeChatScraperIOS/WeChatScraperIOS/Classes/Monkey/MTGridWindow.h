//
//  MTGridWindow.h
//  TypeTest
//
//  Created by tcui on 12/6/15.
//  Copyright (c) 2015 Tong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTVCSense;

@interface MTGridWindow : UIWindow

@property (nonatomic, assign) BOOL gridViewHidden;

+ (instancetype)sharedInstance;

- (void)drawGridWithSense:(MTVCSense *)sense;
- (void)cleanAllMaskViews;

- (void)updateGrid;
- (void)showClicked:(CGPoint)point;

-(void)showMovementFrom:(CGPoint)fromPoint to:(CGPoint)toPoint;

@end
