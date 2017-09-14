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
    return model;
}

- (BOOL)isReady:(NSString *)vcClassName {
    return [vcClassName isEqualToString:self.pageClassName];
}

- (void)run:(id<WFTaskModelDelegate>)caller {
    NSLog(@"Will Do Task: %@", self.desc);
    self.operation(caller, self);
}

- (void)notifySuccessDelay:(NSTimeInterval)delay {
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(taskDidFinish:)]) {
            [weakSelf.delegate taskDidFinish:weakSelf];
        }
    });
    
}

@end
