//
//  WFTaskModel.m
//  WeChatScraperIOS
//
//  Created by tcui on 14/9/2017.
//  Copyright © 2017 LuckyTR. All rights reserved.
//

#import "WFTaskModel.h"
#import "WFTaskManager.h"

@implementation WFTaskModel

+ (instancetype)taskWithDesc:(NSString *)desc pageClassName:(NSString *)pageClassName operation:(void (^)(id<WFTaskModelDelegate> caller, WFTaskModel* task))operation {
    WFTaskModel *model = [[WFTaskModel alloc] init];
    model.desc = desc;
    model.pageClassName = pageClassName;
    model.operation = operation;
    model.delay = 0.5f;
    return model;
}

- (BOOL)isReady:(NSString *)vcClassName {
    return self.isTest || [vcClassName isEqualToString:self.pageClassName];
}

- (void)run:(id<WFTaskModelDelegate>)caller {
    
    self.delegate = caller;
    self.operation(caller, self);
    
}

- (UIViewController *)viewController {
    return [WFTaskManager sharedInstance].lastViewController;
}

- (void)notifySuccessDelay:(NSTimeInterval)delay {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wignored-attributes"
    __weak __typeof(self)weakSelf = self;
#pragma clang diagnostic pop
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(taskDidFinish:)]) {
            [weakSelf.delegate taskDidFinish:weakSelf];
        }
    });
    
}

- (void)notifyFailed:(NSString *)errorMessage {
    if (self.delegate && [self.delegate respondsToSelector:@selector(taskDidFail:message:)]) {
        [self.delegate taskDidFail:self message:errorMessage];
    }
}

@end
