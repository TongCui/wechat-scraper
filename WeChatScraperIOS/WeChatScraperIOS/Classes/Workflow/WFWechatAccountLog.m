//
//  WFWechatAccountLog.m
//  WeChatScraperIOS
//
//  Created by tcui on 15/9/2017.
//  Copyright © 2017 LuckyTR. All rights reserved.
//

#import "WFWechatAccountLog.h"
#import "WFWechatArticleLog.h"
#import "NSDictionary+Tools.h"

@implementation WFWechatAccountLog

- (NSMutableArray<WFWechatArticleLog *> *)articles {
    if (nil == _articles) {
        _articles = [NSMutableArray array];
    }
    return _articles;
}

- (NSMutableArray<NSString *> *)articleElementIds {
    if (nil == _articleElementIds) {
        _articleElementIds = [NSMutableArray array];
    }
    return _articleElementIds;
}


+ (instancetype)accountWithID:(NSString *)accountId {
    WFWechatAccountLog *model = [[WFWechatAccountLog alloc] init];
    model.accountId = accountId;
    return model;
}

- (BOOL)shouldAddProperty:(NSString *)property intoInfoDict:(NSMutableDictionary *)infoDict {
    if ([property isEqualToString:@"accountId"] || [property isEqualToString:@"accountInfo"]) {
        return NO;
    }
    return [super shouldAddProperty:property intoInfoDict:infoDict];
}

- (NSMutableDictionary *)infoDict {
    NSMutableDictionary *dict = [super infoDict];
    
    [dict setSafeObject:self.accountId forKey:@"id"];
    [dict setSafeObject:self.accountInfo forKey:@"info"];
    
    return dict;
}

@end
