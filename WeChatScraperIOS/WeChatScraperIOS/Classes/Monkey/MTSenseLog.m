//
//  MTSenseOperation.m
//  SimpleMonkey
//
//  Created by tcui on 30/7/15.
//  Copyright (c) 2015 LuckyTR. All rights reserved.
//

#import "MTSenseLog.h"


@implementation MTSenseLog

static NSArray *senseTypeDescs = nil;

+ (instancetype)LogWithSenseType:(UIVCSenseType)type operationDesc:(NSString *)operationDesc {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        senseTypeDescs = @[@"TypeUnknown",@"TypeAlert",@"TypePreLogin",@"TypeLogin",@"TypeFullScreenWebPage",@"TypeLoginWaiting",@"TypeWebLoginWaiting",@"TypeScroll",@"TypeHuman",@"TypeMonkey"];
    });
    
    MTSenseLog *operation = [[MTSenseLog alloc] init];
    operation.type = type;
    operation.operation = [NSString stringWithFormat:@"[%@]|%@", senseTypeDescs[type], operationDesc];
    
    return operation;
}

+ (instancetype)watingLogWithSenseType:(UIVCSenseType)type {
    return [[self class] LogWithSenseType:type operationDesc:@"Waiting for last operation finished"];
}

+ (instancetype)pointLogWithSenseType:(UIVCSenseType)type point:(CGPoint)point {
    return [[self class] LogWithSenseType:type operationDesc:[NSString stringWithFormat:@"Touch Point At %@", NSStringFromCGPoint(point)]];
}

+ (instancetype)swipeLogWithSenseType:(UIVCSenseType)type point:(CGPoint)point {
    return [[self class] LogWithSenseType:type operationDesc:[NSString stringWithFormat:@"Scroll from %@", NSStringFromCGPoint(point)]];
}

+ (instancetype)typeLogWithSenseType:(UIVCSenseType)type string:(NSString *)string {
    return [[self class] LogWithSenseType:type operationDesc:[NSString stringWithFormat:@"Typing into keyboard %@", string]];
}


@end
