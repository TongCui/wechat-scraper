//
//  WFTaskManager.h
//  WeChatScraperIOS
//
//  Created by tcui on 14/9/2017.
//  Copyright © 2017 LuckyTR. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WFTaskManager : NSObject

+ (instancetype)sharedInstance;
- (void)setup;
- (void)start;

@end
