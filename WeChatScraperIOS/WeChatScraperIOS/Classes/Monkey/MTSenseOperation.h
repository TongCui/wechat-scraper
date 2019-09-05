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

@interface MTSenseOperation : NSObject

@property (nonatomic, assign) UIVCSenseType type;
@property (nonatomic, copy) NSString *operation;

+ (instancetype)watingOperationWithSenseType:(UIVCSenseType)type;
+ (instancetype)pointOperationWithSenseType:(UIVCSenseType)type point:(CGPoint)point;
+ (instancetype)swipeOperationWithSenseType:(UIVCSenseType)type point:(CGPoint)point;
+ (instancetype)typeOperationWithSenseType:(UIVCSenseType)type string:(NSString *)string;


@end
