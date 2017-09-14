//
//  WFWorkflow.m
//  WeChatScraperIOS
//
//  Created by tcui on 14/9/2017.
//  Copyright © 2017 LuckyTR. All rights reserved.
//

#import "WFWorkflow.h"
#import "WFTaskModel.h"
#import "MTAutomationBridge.h"


@implementation WFWorkflow

+ (NSArray<WFTaskModel *> *)wechatScraperWorkflow {
    return nil;
}

+ (NSArray<WFTaskModel *> *)testWorkflow {
    NSMutableArray *tasks = [NSMutableArray array];
    WFTaskModel *task = nil;
    
    task = [WFTaskModel taskWithDesc:@"Test 1" pageClassName:@"ViewController" operation:^(id<WFTaskModelDelegate> caller, WFTaskModel *task) {
        [MTAutomationBridge tapPoint:CGPointMake(100, 200)];
        [task notifySuccessDelay:.5f];
    }];
    [tasks addObject:task];
    
    task = [WFTaskModel taskWithDesc:@"Test 2" pageClassName:@"ViewController" operation:^(id<WFTaskModelDelegate> caller, WFTaskModel *task) {
        [MTAutomationBridge tapPoint:CGPointMake(200, 200)];
        [task notifySuccessDelay:.5f];
    }];
    [tasks addObject:task];
    
    for (NSUInteger i = 0; i < 10; i++) {
        task = [WFTaskModel taskWithDesc:[NSString stringWithFormat:@"%ld", i + 3] pageClassName:@"ViewController" operation:^(id<WFTaskModelDelegate> caller, WFTaskModel *task) {
            [MTAutomationBridge tapPoint:CGPointMake(10 + i * 20, 200)];
            [task notifySuccessDelay:.5f];
        }];
        [tasks addObject:task];
    }
    
    
    return [tasks copy];
}

@end
