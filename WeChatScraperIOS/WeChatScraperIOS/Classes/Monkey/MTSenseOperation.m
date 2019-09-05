//
//  MTSenseOperation.m
//  SimpleMonkey
//
//  Created by tcui on 30/7/15.
//  Copyright (c) 2015 LuckyTR. All rights reserved.
//

#import "MTSenseOperation.h"


@implementation MTSenseOperation

static NSArray *senseTypeDescs = nil;

+ (instancetype)operationWithSenseType:(UIVCSenseType)type operationDesc:(NSString *)operationDesc {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        senseTypeDescs = @[@"TypeUnknown",@"TypeAlert",@"TypePreLogin",@"TypeLogin",@"TypeFullScreenWebPage",@"TypeLoginWaiting",@"TypeWebLoginWaiting",@"TypeScroll",@"TypeHuman",@"TypeMonkey"];
    });
    
    MTSenseOperation *operation = [[MTSenseOperation alloc] init];
    operation.type = type;
    operation.operation = [NSString stringWithFormat:@"[%@]|%@", senseTypeDescs[type], operationDesc];
    
    return operation;
}

+ (instancetype)watingOperationWithSenseType:(UIVCSenseType)type {
    return [[self class] operationWithSenseType:type operationDesc:@"Waiting for last operation finished"];
}

+ (instancetype)pointOperationWithSenseType:(UIVCSenseType)type point:(CGPoint)point {
    return [[self class] operationWithSenseType:type operationDesc:[NSString stringWithFormat:@"Touch Point At %@", NSStringFromCGPoint(point)]];
}

+ (instancetype)swipeOperationWithSenseType:(UIVCSenseType)type point:(CGPoint)point {
    return [[self class] operationWithSenseType:type operationDesc:[NSString stringWithFormat:@"Scroll from %@", NSStringFromCGPoint(point)]];
}

+ (instancetype)typeOperationWithSenseType:(UIVCSenseType)type string:(NSString *)string {
    return [[self class] operationWithSenseType:type operationDesc:[NSString stringWithFormat:@"Typing into keyboard %@", string]];
}


@end
