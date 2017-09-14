//
//  WFTaskModel.h
//  WeChatScraperIOS
//
//  Created by tcui on 14/9/2017.
//  Copyright © 2017 LuckyTR. All rights reserved.
//

#import "DDBaseItem.h"


@class WFTaskManager;
@class WFTaskModel;

@protocol WFTaskModelDelegate <NSObject>

@optional
- (void)taskDidFinish:(WFTaskModel *)task;
- (void)taskDidFail:(WFTaskModel *)task message:(NSString *)errorMessage;
- (void)taskWillKeepWaiting:(WFTaskModel *)task;

@end


@interface WFTaskModel : DDBaseItem

+ (instancetype)taskWithDesc:(NSString *)desc pageClassName:(NSString *)pageClassName operation:(void (^)(id<WFTaskModelDelegate> caller, WFTaskModel* task))operation;

@property (nonatomic, weak) id<WFTaskModelDelegate> delegate;
@property (nonatomic, copy) NSString *pageClassName;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) void (^operation)(id<WFTaskModelDelegate> caller, WFTaskModel *task);


- (BOOL)isReady:(NSString *)vcClassName;
- (void)run:(id<WFTaskModelDelegate>)caller;
- (void)notifySuccessDelay:(NSTimeInterval)delay;

@end
