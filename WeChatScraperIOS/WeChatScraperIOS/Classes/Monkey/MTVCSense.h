//
//  UIVCSense.h
//  TypeTest
//
//  Created by tcui on 16/6/15.
//  Copyright (c) 2015 Tong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

@interface MTVCSense : NSObject

@property (nonatomic, assign) BOOL containsDisabledViewController;

@property (atomic, strong) NSDate *startTime;
@property (atomic, assign) NSTimeInterval duration;
@property (nonatomic, strong) NSMutableArray *operations;

@property (atomic, strong) NSSet *viewControllerNames;
@property (atomic, strong) NSHashTable *viewHashTable;

@property (atomic, strong) NSHashTable *alertTapableViews;
@property (atomic, strong) NSHashTable *preloginTapableViews;
@property (atomic, strong) NSHashTable *importantTapableViews;
@property (atomic, strong) NSHashTable *tapableViews;

@property (atomic, strong) NSHashTable *textFields;
@property (atomic, strong) NSHashTable *fullScreenWebViews;
@property (atomic, strong) NSHashTable *scrollViews;

@property (nonatomic, assign) UIVCSenseType type;
@property (atomic, assign) BOOL keyboardShown;
@property (atomic, readonly, strong) NSArray *allViews;
@property (atomic, assign, getter=isDoingAutomation) BOOL doingAutomation;

+ (instancetype)currentSense;

- (BOOL)isEqualToSense:(MTVCSense *)sense;
- (void)copyUIElementsFromSense:(MTVCSense *)sense;
- (void)doAutomation;



@end
