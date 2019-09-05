//
//  WFTaskManager.h
//  WeChatScraperIOS
//
//  Created by tcui on 14/9/2017.
//  Copyright © 2017 LuckyTR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class WFWechatSessionLog;

@interface WFTaskManager : NSObject

@property (nonatomic, weak) UIViewController *lastViewController;
@property (nonatomic, strong) NSString *lastVCClassName;

@property (nonatomic, strong) WFWechatSessionLog *log;

+ (instancetype)sharedInstance;
- (void)setup;
- (void)setupTest;
- (void)start;

@end
