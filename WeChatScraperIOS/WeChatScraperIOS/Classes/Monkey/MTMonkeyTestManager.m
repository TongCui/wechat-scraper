//
//  AAVCAnalytics.m
//  TypeTest
//
//  Created by tcui on 12/6/15.
//  Copyright (c) 2015 Tong. All rights reserved.
//

#import "MTMonkeyTestManager.h"
#import "MTGridWindow.h"
#import "Global.h"
#import "MTVCSense.h"
#import "MTSenseLog.h"
#import "UIAutomationBridge.h"
#import "UIApplication+Tools.h"
#import "DDSwizzleManager.h"
#import "UIImage+Tools.h"
#import "UIAutomation.h"

@interface UIWindow (Private)
+(id)keyWindow;
+(id)_findWithDisplayPoint:(CGPoint)displayPoint;
@end

@interface MTMonkeyTestManager ()

@property (nonatomic, assign) BOOL checkTimerShouldResume;

@property (nonatomic, strong) NSMutableArray *logs;


@end

@implementation MTMonkeyTestManager

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification
- (void)applicationDidEnterBackground {
    [self updateLogWithSense:[self.senseArray lastObject] updateDuration:YES];
    [self stopTimer];
}

- (void)applicationWillEnterForeground {
#ifdef LOCALMONKEYTEST
    if (self.checkTimerShouldResume) {
        [self startTimer];
    }
#endif
}

#pragma mark - Life cycle
+(instancetype)sharedInstance{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[MTMonkeyTestManager alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.senseArray = [NSMutableArray array];
        self.logs = [NSMutableArray array];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)analyticsVCSense {
    self.timerCount = (self.timerCount + 1) % 3;
    DDLog(@"TimerCount : (%ld)", (long)self.timerCount);
    
    MTVCSense *currentSense = [MTVCSense currentSense];
    MTVCSense *lastSense = [self.senseArray lastObject];
    
    if ([currentSense isEqualToSense:lastSense]) {
        MTVCSense *lastSense = [self.senseArray lastObject];
        [lastSense copyUIElementsFromSense:currentSense];
        currentSense = lastSense;
        
        DDLog(@"Same Sense %@", currentSense);
    } else {
        if (nil != lastSense) {
            
            [self updateLogWithSense:lastSense updateDuration:YES];
        }
        
        DDLog(@"Add new sense (index : %ld)", (long)self.senseArray.count);
        [self.senseArray addObject:currentSense];
        
        NSUInteger idx = self.senseArray.count - 1;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *screenShot = [UIImage screenshotWithView:[UIWindow keyWindow]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIImageJPEGRepresentation(screenShot, 0.9) writeToFile:[[UIApplication sharedApplication] monkeytestScreenShotFilePathWithIndex:idx] atomically:YES];
            });
        });
    }
    
    //  Draw
    [[MTGridWindow sharedInstance] drawGridWithSense:currentSense];
    
    if (self.timerCount == 0) {
        [currentSense doAutomation];
    }

}

#pragma mark - Log
- (void)updateLogWithSense:(MTVCSense *)sense updateDuration:(BOOL)updateDuration {
    if (nil == sense) {
        return;
    }
    
    if (updateDuration) {
        sense.duration = [[NSDate date] timeIntervalSinceDate:sense.startTime];
    }
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    info[@"startTime"] = [sense.startTime description];
    info[@"duration"] = @(sense.duration);
    NSMutableArray *operations = [NSMutableArray array];
    [sense.operations enumerateObjectsUsingBlock:^(MTSenseLog *obj, NSUInteger idx, BOOL *stop) {
        [operations addObject:obj.operation];
    }];
    
    if (operations.count == 0) {
        DDLog(@"empty operation!!");
    }
    
    info[@"operations"] = operations;
    
    
    [self.logs addObject:info];
    [self saveLog];
}

- (void)updateLogWithSense:(MTVCSense *)sense {
    [self updateLogWithSense:sense updateDuration:NO];
}

- (void)saveLog {
    NSLog(@"!!!!!!!!!!!!!!Write to file %@", [UIApplication sharedApplication].monkeytestLogFilePath);
    [self.logs writeToFile:[UIApplication sharedApplication].monkeytestLogFilePath atomically:YES];
}


#pragma mark - Notification

-(void)applicationDidFinishLaunch {
    [[DDSwizzleManager sharedInstance] swizzleMethods];
    UIWindow *keyWindow = [UIWindow keyWindow];
    [[MTGridWindow sharedInstance] makeKeyAndVisible];
    [MTGridWindow sharedInstance].userInteractionEnabled = NO;
//    [MTGridWindow sharedInstance].gridViewHidden = YES;
    [keyWindow makeKeyAndVisible];
    NSString *beginNotify = [NSString stringWithFormat:@"com.plipala.monkeytest.beginanalytics-%@",[[NSBundle mainBundle] bundleIdentifier]];
    DDLog(@"beginNotify %@",beginNotify);
    NSString *stopNotify = [NSString stringWithFormat:@"com.plipala.monkeytest.stopanalytics-%@",[[NSBundle mainBundle] bundleIdentifier]];
    DDLog(@"stopNotify %@",stopNotify);
    id observer = [MTMonkeyTestManager sharedInstance];
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), (__bridge const void *)observer, &beginAnalytics, (CFStringRef)beginNotify, NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), (__bridge const void *)observer, &stopAnalytics, (CFStringRef)stopNotify, NULL, CFNotificationSuspensionBehaviorCoalesce);
}

#pragma mark - Timer
- (void)startTimer {
    if (![UIApplication sharedApplication].monkeytestAvailable) {
        return;
    }

    [self.checkTimer invalidate];
    self.checkTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:[MTMonkeyTestManager sharedInstance] selector:@selector(analyticsVCSense) userInfo:nil repeats:YES];
    
    self.checkTimerShouldResume = YES;
}

- (void)stopTimer {
    [self.checkTimer invalidate];
    self.checkTimer = nil;
}

#pragma mark - Notification

static void beginAnalytics(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    [[MTMonkeyTestManager sharedInstance] startTimer];
}

static void stopAnalytics(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    [[MTMonkeyTestManager sharedInstance] stopTimer];
}


@end
