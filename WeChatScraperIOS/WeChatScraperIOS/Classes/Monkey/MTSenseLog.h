//
//  MTSenseOperation.h
//  SimpleMonkey
//
//  Created by tcui on 30/7/15.
//  Copyright (c) 2015 LuckyTR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Global.h"

@interface MTSenseLog : NSObject

@property (nonatomic, assign) UIVCSenseType type;
@property (nonatomic, copy) NSString *operation;

+ (instancetype)watingLogWithSenseType:(UIVCSenseType)type;
+ (instancetype)pointLogWithSenseType:(UIVCSenseType)type point:(CGPoint)point;
+ (instancetype)swipeLogWithSenseType:(UIVCSenseType)type point:(CGPoint)point;
+ (instancetype)typeLogWithSenseType:(UIVCSenseType)type string:(NSString *)string;


@end
