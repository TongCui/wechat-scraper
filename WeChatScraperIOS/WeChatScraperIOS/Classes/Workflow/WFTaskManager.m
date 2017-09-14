//
//  WFTaskManager.m
//  WeChatScraperIOS
//
//  Created by tcui on 14/9/2017.
//  Copyright © 2017 LuckyTR. All rights reserved.
//

#import "WFTaskManager.h"
#import "WFTaskModel.h"
#import "Global.h"
#import "WFWorkflow.h"

@interface WFTaskManager () <WFTaskModelDelegate>

@property (nonatomic, strong) NSArray<WFTaskModel *> *tasks;
@property (nonatomic, strong) NSString *lastViewController;
@property (nonatomic, assign) BOOL isRunning;

@end

@implementation WFTaskManager

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Life cycle
+ (instancetype)sharedInstance {
    static WFTaskManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[WFTaskManager alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidAppearNotification:) name:kWF_ViewController_DidAppear_Notification object:nil];
    });
    return _sharedInstance;
}

- (void)setup {
    self.tasks = [WFWorkflow wechatScraperWorkflow];
}

- (void)consume {
    WFTaskModel *firstTask = self.tasks.firstObject;
    if ([firstTask isReady:self.lastViewController]) {
        [firstTask run:self];
    } else {
        [self notifyError:@"[WF Error] Expected page is not shown!"];
    }
}

- (void)notifyError:(NSString *)errorMessage {
    //  TODO:
}

#pragma mark - Notifications
- (void)viewDidAppearNotification:(NSNotification *)notification {
    self.lastViewController = notification.userInfo[@"class"];
    DDLog(@"[WF]Update Last ViewController %@", notification.userInfo);
    if (!self.isRunning && [self.tasks.firstObject isReady:self.lastViewController]) {
        [self consume];
    }
}

#pragma mark - WSTaskModelDelgate
- (void)taskDidFinish:(WFTaskModel *)task {
    DDLog(@"[WF] Task is finished: %@", task.desc);
    [self consume];
}

- (void)taskDidFail:(WFTaskModel *)task message:(NSString *)errorMessage {

}
- (void)taskWillKeepWaiting:(WFTaskModel *)task {

}


@end
