//
//  AppDelegate.m
//  WeChatScraperIOS
//
//  Created by tcui on 13/9/2017.
//  Copyright © 2017 LuckyTR. All rights reserved.
//

#import "AppDelegate.h"
#import "UIApplication+Tools.h"
#import "Global.h"
#include <dlfcn.h>
#import "MTGridWindow.h"
#import "MTMonkeyTestManager.h"
#import "DDSwizzleManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[DDSwizzleManager sharedInstance] swizzleMethods];
    
    NSArray *fromAppCachePathContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:CACHES_FOLDER error:nil];
    
    NSLog(@"%@", CACHES_FOLDER);
    NSLog(@"%@", fromAppCachePathContents);
    
    NSDictionary *dict = @{@"test": @"https://api-us-int.smart-sense.org/2014-07-16/is_enabled?did=3B8F15D5-E559-4264-8F54-4B4D9DAF8817&version=1.0"};
    [dict writeToFile:[CACHES_FOLDER stringByAppendingPathComponent:@"test.plist"] atomically:YES];
    
    [fromAppCachePathContents enumerateObjectsUsingBlock:^(NSString *filePath, NSUInteger idx, BOOL *stop) {
        if ([filePath isEqualToString:@"monkeytest.plist"]) {
            //Do
        } else if ([filePath hasPrefix:@"screenshot"]) {
            
        }
    }];
    
    [UIApplication sharedApplication].monkeytestAvailable = NO;
    [UIApplication sharedApplication].monkeytestDebug = YES;
    [UIApplication sharedApplication].shouldLogin = NO;
    
    [UIApplication sharedApplication].userName = @"tcui@appannie.com";
    [UIApplication sharedApplication].password = @"112233\n";
    
    [[MTGridWindow sharedInstance] makeKeyAndVisible];
    [MTGridWindow sharedInstance].userInteractionEnabled = NO;
    
    DDLog(@"linking UIAutomation framework...");
    dlopen([@"/Developer/Library/PrivateFrameworks/UIAutomation.framework/UIAutomation" fileSystemRepresentation], RTLD_LOCAL);
    
    
    return YES;
}


@end
