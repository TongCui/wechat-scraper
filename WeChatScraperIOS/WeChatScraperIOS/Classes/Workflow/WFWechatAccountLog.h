//
//  WFWechatAccountLog.h
//  WeChatScraperIOS
//
//  Created by tcui on 15/9/2017.
//  Copyright © 2017 LuckyTR. All rights reserved.
//

#import "DDBaseItem.h"

@class WFWechatArticleLog;

@interface WFWechatAccountLog : DDBaseItem

@property (nonatomic, copy) NSString *accountId;
@property (nonatomic, strong) NSDictionary *accountInfo;
@property (nonatomic, strong) NSMutableArray<NSString *> *articleElementIds;
@property (nonatomic, strong) NSMutableArray<WFWechatArticleLog *> *articles;


+ (instancetype)accountWithID:(NSString *)accountId;

@end
