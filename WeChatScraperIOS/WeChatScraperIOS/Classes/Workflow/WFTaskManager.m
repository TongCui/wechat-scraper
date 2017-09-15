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
#import "DDJSONKit.h"

#import "WFWechatSessionLog.h"
#import "WFWechatAccountLog.h"
#import "WFWechatArticleLog.h"

@interface WFTaskManager () <WFTaskModelDelegate>

@property (nonatomic, strong) NSMutableArray<WFTaskModel *> *tasks;
@property (nonatomic, assign) BOOL isRunning;


@end

@implementation WFTaskManager

#pragma mark - Accessors
- (WFWechatSessionLog *)log {
    if (nil == _log) {
        _log = [[WFWechatSessionLog alloc] init];
    }
    return _log;
}


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

- (void)setupTest {
    self.tasks = [[WFWorkflow testWorkflow] mutableCopy];
}


- (void)start {
    [self.tasks.firstObject run:self];
}

- (void)consume {
    WFTaskModel *firstTask = self.tasks.firstObject;
    DDLog(@"~~~%@, %@", self.lastVCClassName, self.lastViewController);
    DDLog(@"~~~%@", firstTask.pageClassName);
    
    DDLog(@"[WF] Will Do Task (with delay %f) (target page %@): %@", firstTask.delay, firstTask.pageClassName, firstTask.desc);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(firstTask.delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([firstTask isReady:self.lastVCClassName]) {
            DDLog(@"run");
            [firstTask run:self];
        } else {
            [self notifyError:@"[WF Error] Expected page is not shown!"];
        }
        
    });
    
    
}

- (void)notifyError:(NSString *)errorMessage {
    [self.tasks removeAllObjects];
    self.isRunning = NO;
    DDLog(@"%@", errorMessage);
    DDLog(@"======");
    DDLog(@"%@", self.log.infoDict.JSONString);
}

- (void)notifyFinish {
    self.isRunning = NO;
    DDLog(@"All Tasks are finished!! Well Done!!!");
    DDLog(@"======");
    DDLog(@"%@", self.log.infoDict.JSONString);
}

#pragma mark - Notifications
- (BOOL)shouldIgnoreViewController:(UIViewController *)viewController {
    if (nil == viewController) {
        return YES;
    }
    NSString *className = [[viewController class] description];
    if ([className hasPrefix:@"UI"] || [className hasPrefix:@"_"]) {
        return YES;
    }
    return NO;
}

- (void)viewDidAppearNotification:(NSNotification *)notification {
    if ([self shouldIgnoreViewController:notification.object]) {
        NSLog(@"Should ignore viewcontroller %@", notification.object);
        return;
    }
    self.lastViewController = notification.object;
    self.lastVCClassName = [[self.lastViewController class] description];
    
    DDLog(@"[WF]Update Last ViewController %@", self.lastVCClassName);
    if (!self.isRunning && [self.tasks.firstObject isReady:self.lastVCClassName]) {
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
        DDLog(@"[WF] Finish All Tasks");
        [self notifyFinish];
    } else {
        DDLog(@"[WF] Consume Next Task");
        [self consume];
    }
    
}

- (void)taskDidFail:(WFTaskModel *)task message:(NSString *)errorMessage {

}
- (void)taskWillKeepWaiting:(WFTaskModel *)task {

}


@end
