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

+ (NSArray<NSString *> *)targetIds {
    return @[
             @"rmrbwx",
             @"zhanhao668",
             @"yetingfm",
             @"lengtoo",
             @"mimeng7",
             @"QQ_shijuezhi",
             @"duhaoshu",
             @"gaoshi222",
             @"lengxiaohua2012",
             @"xinhuashefabu1",
             ];
}

+ (NSArray<WFTaskModel *> *)wechatScraperWorkflow {
    NSMutableArray *tasks = [NSMutableArray array];
    WFTaskModel *task = nil;
    
    NSTimeInterval delay = 1.2f;
    
    task = [WFTaskModel taskWithDesc:@"tap '订阅号'" pageClassName:@"NewMainFrameViewController" operation:^(id<WFTaskModelDelegate> caller, WFTaskModel *task) {
        [MTAutomationBridge tapPoint:CGPointMake(180, 180)];
        [task notifySuccessDelay:delay];
    }];
    [tasks addObject:task];
    
    task = [WFTaskModel taskWithDesc:@"tap '果壳'" pageClassName:@"BrandSessionViewController" operation:^(id<WFTaskModelDelegate> caller, WFTaskModel *task) {
        [MTAutomationBridge tapPoint:CGPointMake(180, 140)];
        [task notifySuccessDelay:delay];
    }];
    [tasks addObject:task];
    
    task = [WFTaskModel taskWithDesc:@"tap 'Setting'" pageClassName:@"BaseMsgContentViewController" operation:^(id<WFTaskModelDelegate> caller, WFTaskModel *task) {
        [MTAutomationBridge tapPoint:CGPointMake(360, 40)];
        [task notifySuccessDelay:delay];
    }];
    [tasks addObject:task];
    
    task = [WFTaskModel taskWithDesc:@"tap '查看历史消息'" pageClassName:@"ContactInfoViewController" operation:^(id<WFTaskModelDelegate> caller, WFTaskModel *task) {
        [MTAutomationBridge tapPoint:CGPointMake(180, 410)];
        [task notifySuccessDelay:delay];
    }];
    [tasks addObject:task];
    
    task = [WFTaskModel taskWithDesc:@"Waiting for page loaded, and collect html" pageClassName:@"MMWebViewController" operation:^(id<WFTaskModelDelegate> caller, WFTaskModel *task) {
        [task notifySuccessDelay:delay];
    }];
    task.delay = 1.5;
    [tasks addObject:task];
    
    task = [WFTaskModel taskWithDesc:@"Tap Article" pageClassName:@"MMWebViewController" operation:^(id<WFTaskModelDelegate> caller, WFTaskModel *task) {
        [MTAutomationBridge tapPoint:CGPointMake(180, 350)];
        [task notifySuccessDelay:delay];
    }];
    [tasks addObject:task];
    
    task = [WFTaskModel taskWithDesc:@"Waiting for page loaded, and collect html" pageClassName:@"MMWebViewController" operation:^(id<WFTaskModelDelegate> caller, WFTaskModel *task) {
        [task notifySuccessDelay:delay];
    }];
    task.delay = 1.5;
    [tasks addObject:task];
    
    task = [WFTaskModel taskWithDesc:@"Tap Back" pageClassName:@"MMWebViewController" operation:^(id<WFTaskModelDelegate> caller, WFTaskModel *task) {
        [MTAutomationBridge tapPoint:CGPointMake(30, 40)];
        [task notifySuccessDelay:delay];
    }];
    [tasks addObject:task];
    
    task = [WFTaskModel taskWithDesc:@"Tap Article" pageClassName:@"MMWebViewController" operation:^(id<WFTaskModelDelegate> caller, WFTaskModel *task) {
        [MTAutomationBridge tapPoint:CGPointMake(180, 460)];
        [task notifySuccessDelay:delay];
    }];
    [tasks addObject:task];
    
    task = [WFTaskModel taskWithDesc:@"Waiting for page loaded, and collect html" pageClassName:@"MMWebViewController" operation:^(id<WFTaskModelDelegate> caller, WFTaskModel *task) {
        [task notifySuccessDelay:delay];
    }];
    task.delay = 1.5;
    [tasks addObject:task];
    
    task = [WFTaskModel taskWithDesc:@"Tap Back" pageClassName:@"MMWebViewController" operation:^(id<WFTaskModelDelegate> caller, WFTaskModel *task) {
        [MTAutomationBridge tapPoint:CGPointMake(30, 40)];
        [task notifySuccessDelay:delay];
    }];
    [tasks addObject:task];
    
    
    return [tasks copy];
}

+ (NSArray<WFTaskModel *> *)testWorkflow {
    NSMutableArray *tasks = [NSMutableArray array];
    WFTaskModel *task = nil;
    
    task = [WFTaskModel taskWithDesc:@"Test 1" pageClassName:@"ViewController" operation:^(id<WFTaskModelDelegate> caller, WFTaskModel *task) {
        [MTAutomationBridge tapPoint:CGPointMake(100, 200)];
        [task notifySuccessDelay:.5f];
    }];
    task.isTest = YES;
    [tasks addObject:task];
    
    task = [WFTaskModel taskWithDesc:@"Test 2" pageClassName:@"ViewController" operation:^(id<WFTaskModelDelegate> caller, WFTaskModel *task) {
        [MTAutomationBridge tapPoint:CGPointMake(200, 200)];
        [task notifySuccessDelay:.5f];
    }];
    task.isTest = YES;
    [tasks addObject:task];
    
    for (NSUInteger i = 0; i < 10; i++) {
        task = [WFTaskModel taskWithDesc:[NSString stringWithFormat:@"%ld", (long)(i + 3)] pageClassName:@"ViewController" operation:^(id<WFTaskModelDelegate> caller, WFTaskModel *task) {
            [MTAutomationBridge tapPoint:CGPointMake(10 + i * 20, 200)];
            [task notifySuccessDelay:.5f];
        }];
        task.isTest = YES;
        [tasks addObject:task];
    }
    
    
    return [tasks copy];
}

@end
