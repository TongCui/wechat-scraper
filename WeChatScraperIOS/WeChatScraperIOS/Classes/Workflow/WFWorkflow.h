//
//  WFWorkflow.h
//  WeChatScraperIOS
//
//  Created by tcui on 14/9/2017.
//  Copyright © 2017 LuckyTR. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WFTaskModel;

@interface WFWorkflow : NSObject

+ (NSArray<WFTaskModel *> *)wechatScraperWorkflow;
+ (NSArray<WFTaskModel *> *)testWorkflow;

@end
