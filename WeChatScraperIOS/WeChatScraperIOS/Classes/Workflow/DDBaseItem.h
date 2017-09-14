//
//  PMBaseItem.h
//  PMP
//
//  Created by Tong on 06/03/2014.
//  Copyright (c) 2014 LuckyTR. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DDBaseItemBool) {
    DDBaseItemBoolUnknown = -1,
    DDBaseItemBoolFalse = 0,
    DDBaseItemBoolTrue = 1
};

typedef void (^DDBaseItemPropertyBlock)(NSString *propertyName, NSString *className);

#define kDDBaseItemInt_UnKnown      (-1)

@interface DDBaseItem : NSObject

- (instancetype)init;
- (instancetype)initWithDict:(NSDictionary *)dict;
- (void)keyValuesAssignmentWithDict:(NSDictionary *)dict;


/** Common */
@property (nonatomic, copy) NSString *ddId;
@property (nonatomic, assign) BOOL fake;

+ (DDBaseItemBool)baseItemBoolFromInfo:(NSDictionary *)info keyword:(NSString *)keyword;


/** Dict Methods */
- (NSMutableDictionary *)infoDict;
- (BOOL)shouldAddProperty:(NSString *)property intoInfoDict:(NSMutableDictionary *)infoDict;
- (void)propertyDidAddWithProperty:(NSString *)property dict:(NSMutableDictionary *)infoDict;

- (BOOL)shouldReadProperty:(NSString *)property fromInfoDict:(NSDictionary *)infoDict;
- (void)propertyDidReadWithProperty:(NSString *)property dict:(NSDictionary *)infoDict;

+ (id)itemWithDict:(NSDictionary *)dict;

/** Sub Items from dict */
+ (NSArray *)itemsFromInfo:(NSDictionary *)dict keyword:(NSString *)keyword withClass:(Class)itemClass;
+ (NSArray *)itemsFromInfo:(NSDictionary *)dict keyword:(NSString *)keyword withClass:(Class)itemClass itemFactory:(BOOL)itemFactory;
+ (NSDictionary *)itemsInfoFromInfo:(NSDictionary *)dict keyword:(NSString *)keyword withClass:(Class)itemClass;

/** Copy */
- (void)copyValuesFromDict:(NSDictionary *)dict;

/** Save and Load */
+ (NSString *)savePath;
- (void)customSettingsBeforeAutoParse;
- (void)clear;
- (void)clearAndSave;
- (void)save;
+ (id)loadSavedItem;


+ (DDBaseItemBool)reversValueFor:(DDBaseItemBool)baseItemBool;

/** Tripple Value Bool */


@end
