//
//  WFWechatSessionLog.h
//  WeChatScraperIOS
//
//  Created by tcui on 15/9/2017.
//  Copyright © 2017 LuckyTR. All rights reserved.
//

#import "DDBaseItem.h"

@class WFWechatAccountLog;

@interface WFWechatSessionLog : DDBaseItem

@property (nonatomic, strong) NSMutableArray<WFWechatAccountLog *> *accounts;

- (void)appendAccountLog:(WFWechatAccountLog *)accountLog;
- (void)appendAccountInfo:(NSDictionary *)info;
- (void)appendAriticleElementIds:(NSArray<NSString *> *)ids;
- (void)appendHTML:(NSString *)html;

@end
