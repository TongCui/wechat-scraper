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
#import "NSString+Tools.h"
#import "WFWechatSessionLog.h"
#import "WFWechatAccountLog.h"
#import "WFWechatArticleLog.h"
#import "AFNetworking.h"

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
    [self.tasks enumerateObjectsUsingBlock:^(WFTaskModel *task, NSUInteger idx, BOOL * stop) {
        task.taskIndex = idx;
    }];
}

- (void)setupTest {
    self.tasks = [[WFWorkflow testWorkflow] mutableCopy];
}


- (void)start {
    [self.tasks.firstObject run:self];
}

- (void)consume {
    WFTaskModel *firstTask = self.tasks.firstObject;
    
    
    DDLog(@"[WF] Will Do Task (with delay %f) (target page %@): %@", firstTask.delay, firstTask.pageClassName, firstTask.desc);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(firstTask.delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([firstTask isReady:self.lastVCClassName]) {
            [firstTask run:self];
        } else {
            [self notifyError:@"[WF Error] Expected page is not shown!"];
        }
        
    });
    
    
}

- (void)notifyError:(NSString *)errorMessage {
    [self.tasks removeAllObjects];
    self.isRunning = NO;
    DDLog(@"[WF] WorkFlow Failed %@", errorMessage);
}

- (void)notifyFinish {
    self.isRunning = NO;
    DDLog(@"[WF] Success - All Tasks are finished!! Well Done!!!");
    NSString *json = self.log.infoDict.JSONString;

    [self saveLogLocalFile:json];
    [self postLog:json];
}

- (NSString *)dateString {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd-HH:mm:ss";
    
    return [formatter stringFromDate:date];
}

- (void)saveLogLocalFile:(NSString *)json {
    NSString *fileName = [NSString stringWithFormat:@"log_%@.json", [self dateString]];
    NSString *savePath = [NSString filePathOfCachesFolderWithName:fileName];
    BOOL res = [json writeToFile:savePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    DDLog(@"[WF] Save file %@ (%@)", savePath, res ? @"YES" : @"NO");
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
    DDLog(@"[WF] Task(%ld) [%@] is finished", (long)task.taskIndex, task.desc);
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
    DDLog(@"[WF] Task(%ld) [%@] failed with reason (%@)", (long)task.taskIndex, task.desc, errorMessage);
}
- (void)taskWillKeepWaiting:(WFTaskModel *)task {

}

- (void)postLog:(NSString *)log {
    NSString *urlString = @"http://13.229.121.69:8000/foo";
    
    NSData *postData = [log dataUsingEncoding:NSUTF8StringEncoding];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:nil error:nil];
    request.timeoutInterval= 100;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"text/html" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:postData];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            DDLog(@"[WF] Post Success!!!");
        } else {
            DDLog(@"[WF] Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];
}


@end
