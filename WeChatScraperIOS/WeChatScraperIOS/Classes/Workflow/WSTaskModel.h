//
//  WSTaskModel.h
//  WeChatScraperIOS
//
//  Created by tcui on 14/9/2017.
//  Copyright © 2017 LuckyTR. All rights reserved.
//

#import "DDBaseItem.h"

typedef NS_ENUM(NSUInteger, WSTaskType) {
    WSTaskTypeTap,
    WSTaskTypeType,
};

@interface WSTaskModel : DDBaseItem

@property (nonatomic, assign) WSTaskType type;
@property (nonatomic, copy) NSString *name;

@end
