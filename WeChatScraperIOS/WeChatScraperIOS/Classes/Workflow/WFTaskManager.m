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

@property (nonatomic, strong) NSMutableArray<WFTaskModel *> *tasks;
@property (nonatomic, strong) NSString *lastViewController;
@property (nonatomic, assign) BOOL isRunning;


@end

@implementation WFTaskManager




#pragma mark - Life cycle
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)sharedInstance {
    static WFTaskManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[WFTaskManager alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:_sharedInstance selector:@selector(viewDidAppearNotification:) name:kWF_ViewController_DidAppear_Notification object:nil];
    });
    return _sharedInstance;
}

- (void)setup {
    DDLog(@"[WF] setup task manager");
    self.tasks = [[WFWorkflow wechatScraperWorkflow] mutableCopy];
}

- (void)start {
    [self.tasks.firstObject run:self];
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
    self.isRunning = NO;
    //  TODO:
}

- (void)notifyFinish {
    self.isRunning = NO;
    DDLog(@"All Tasks are finished!! Well Done!!!");
}

#pragma mark - Notifications
- (BOOL)shouldIgnoreViewController:(NSString *)viewController {
    if ([viewController hasPrefix:@"UI"] || [viewController hasPrefix:@"_"]) {
        return YES;
    }
    return NO;
}

- (void)viewDidAppearNotification:(NSNotification *)notification {
    if ([self shouldIgnoreViewController:notification.userInfo[@"class"]]) {
        return;
    }
    self.lastViewController = notification.userInfo[@"class"];
    DDLog(@"[WF]Update Last ViewController %@", notification.userInfo);
    if (!self.isRunning && [self.tasks.firstObject isReady:self.lastViewController]) {
        self.isRunning = YES;
        [self consume];
    }
}

#pragma mark - WSTaskModelDelgate
- (void)taskDidFinish:(WFTaskModel *)task {
    DDLog(@"[WF] Task is finished: %@", task.desc);
    if (self.tasks.count > 0) {
        [self.tasks removeObjectAtIndex:0];
    }
    if (self.tasks.count == 0) {
        [self notifyFinish];
    } else {
        [self consume];
    }
    
}

- (void)taskDidFail:(WFTaskModel *)task message:(NSString *)errorMessage {

}
- (void)taskWillKeepWaiting:(WFTaskModel *)task {

}


@end
