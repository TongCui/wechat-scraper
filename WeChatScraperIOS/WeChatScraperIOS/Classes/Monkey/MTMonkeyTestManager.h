//
//  AAVCAnalytics.h
//  TypeTest
//
//  Created by tcui on 12/6/15.
//  Copyright (c) 2015 Tong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class MTVCSense;

@interface MTMonkeyTestManager : NSObject

@property (atomic, strong) NSTimer *checkTimer;
@property (atomic, assign) NSUInteger timerCount;

@property (atomic, strong) NSMutableArray *senseArray;

+ (instancetype)sharedInstance;

/** Timer */
- (void)startTimer;
- (void)stopTimer;

/** Log */
- (void)updateLogWithSense:(MTVCSense *)sense;

@end
