//
//  WFTaskModel.h
//  WeChatScraperIOS
//
//  Created by tcui on 14/9/2017.
//  Copyright © 2017 LuckyTR. All rights reserved.
//
#import <UIKit/UIKit.h>
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

@property (nonatomic, assign) NSUInteger taskIndex;
@property (nonatomic, assign) BOOL isTest;
@property (nonatomic, assign) NSUInteger retryCount;
@property (nonatomic, assign) NSTimeInterval delay;
@property (nonatomic, weak) id<WFTaskModelDelegate> delegate;
@property (nonatomic, copy) NSString *pageClassName;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) void (^operation)(id<WFTaskModelDelegate> caller, WFTaskModel *task);
@property (nonatomic, readonly) UIViewController *viewController;


- (BOOL)isReady:(NSString *)vcClassName;
- (void)run:(id<WFTaskModelDelegate>)caller;
- (void)notifySuccessDelay:(NSTimeInterval)delay;
- (void)notifyFailed:(NSString *)errorMessage;

@end
