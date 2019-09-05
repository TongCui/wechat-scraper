//
//  UIApplication+Tools.m
//  TypeTest
//
//  Created by tcui on 24/6/15.
//  Copyright (c) 2015 Tong. All rights reserved.
//

#import "UIApplication+Tools.h"
#import <objc/runtime.h>
#import "Global.h"

@implementation UIApplication (Tools)

- (BOOL)monkeytestAvailable {
    NSNumber *number = objc_getAssociatedObject(self, @"kMT_monkeytestAvailable");
    return [number boolValue];
}

- (void)setMonkeytestAvailable:(BOOL)monkeytestAvailable {
    NSNumber *number = [NSNumber numberWithBool:monkeytestAvailable];
    objc_setAssociatedObject(self, @"kMT_monkeytestAvailable", number , OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)monkeytestDebug {
    NSNumber *number = objc_getAssociatedObject(self, @"kMT_monkeytestDebug");
    return [number boolValue];
}

- (void)setMonkeytestDebug:(BOOL)monkeytestDebug {
    NSNumber *number = [NSNumber numberWithBool:monkeytestDebug];
    objc_setAssociatedObject(self, @"kMT_monkeytestDebug", number , OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)appSettingsDidFinish {
    NSNumber *number = objc_getAssociatedObject(self, @"kMT_appSettingsDidFinish");
    return [number boolValue];
}

- (void)setAppSettingsDidFinish:(BOOL)appSettingsDidFinish {
    NSNumber *number = [NSNumber numberWithBool:appSettingsDidFinish];
    objc_setAssociatedObject(self, @"kMT_appSettingsDidFinish", number , OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)shouldLogin {
    NSNumber *number = objc_getAssociatedObject(self, @"kMT_shouldLogin");
    return [number boolValue];
}

- (void)setShouldLogin:(BOOL)shouldLogin {
    NSNumber *number = [NSNumber numberWithBool:shouldLogin];
    objc_setAssociatedObject(self, @"kMT_shouldLogin", number , OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)didStartMonkeyTest {
    NSNumber *number = objc_getAssociatedObject(self, @"kMT_didStartMonkeyTest");
    return [number boolValue];
}

- (void)setDidStartMonkeyTest:(BOOL)didStartMonkeyTest {
    NSNumber *number = [NSNumber numberWithBool:didStartMonkeyTest];
    objc_setAssociatedObject(self, @"kMT_didStartMonkeyTest", number , OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)didTryLogin {
    NSNumber *number = objc_getAssociatedObject(self, @"kMT_didTryLogin");
    return [number boolValue];
}

- (void)setDidTryLogin:(BOOL)didTryLogin {
    NSNumber *number = [NSNumber numberWithBool:didTryLogin];
    objc_setAssociatedObject(self, @"kMT_didTryLogin", number , OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)userName {
    DDLog(@"userName");
    return (NSString *)objc_getAssociatedObject(self, @"kMT_username");
}

- (void)setUserName:(NSString *)userName {
    objc_setAssociatedObject(self, @"kMT_username", userName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)password {
    DDLog(@"password");
    return (NSString *)objc_getAssociatedObject(self, @"kMT_password");
}

- (void)setPassword:(NSString *)password {
    objc_setAssociatedObject(self, @"kMT_password", password, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


#define DOCUMENTS_FOLDER    ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0])
#define CACHES_FOLDER       ([NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0])

- (NSString *)monkeytestLogFilePath {
    NSString *filePath = [CACHES_FOLDER stringByAppendingPathComponent:@"monkeytest.plist"];
    return filePath;
}

- (NSString *)monkeytestScreenShotFilePathWithIndex:(NSUInteger)idx {
    NSString *filePath = [CACHES_FOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"screenshot_%ld_image.jpg", (long)idx]];
    return filePath;

}

@end
