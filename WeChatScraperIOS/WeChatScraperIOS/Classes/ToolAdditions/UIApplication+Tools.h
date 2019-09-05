//
//  UIApplication+Tools.h
//  TypeTest
//
//  Created by tcui on 24/6/15.
//  Copyright (c) 2015 Tong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (Tools)

@property (nonatomic, assign) BOOL appSettingsDidFinish;

@property (nonatomic, assign) BOOL monkeytestAvailable;
@property (nonatomic, assign) BOOL monkeytestDebug;

@property (nonatomic, assign) BOOL shouldLogin;
@property (nonatomic, assign) BOOL didStartMonkeyTest;
@property (nonatomic, assign) BOOL didTryLogin;

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, readonly, copy) NSString *monkeytestLogFilePath;

- (NSString *)monkeytestScreenShotFilePathWithIndex:(NSUInteger)idx;

@end
