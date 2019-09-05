//
//  WFWechatSessionLog.m
//  WeChatScraperIOS
//
//  Created by tcui on 15/9/2017.
//  Copyright © 2017 LuckyTR. All rights reserved.
//

#import "WFWechatSessionLog.h"
#import "WFWechatAccountLog.h"
#import "WFWechatArticleLog.h"

@implementation WFWechatSessionLog

- (NSMutableArray<WFWechatAccountLog *> *)accounts {
    if (nil == _accounts) {
        _accounts = [NSMutableArray array];
    }
    return _accounts;
}

- (void)appendAccountLog:(WFWechatAccountLog *)accountLog {
    [self.accounts addObject:accountLog];
}

- (void)appendAccountInfo:(NSDictionary *)info {
    WFWechatAccountLog *lastAccountLog = self.accounts.lastObject;
    lastAccountLog.accountInfo = info;
}


- (void)appendHTML:(NSString *)html {
    WFWechatAccountLog *lastAccountLog = self.accounts.lastObject;
    WFWechatArticleLog *articleLog = [[WFWechatArticleLog alloc] init];
    articleLog.html = html;
    [lastAccountLog.articles addObject:articleLog];
}

- (void)appendAriticleElementIds:(NSArray<NSString *> *)ids {
    WFWechatAccountLog *lastAccountLog = self.accounts.lastObject;
    lastAccountLog.articleElementIds = [ids mutableCopy];
}

@end
