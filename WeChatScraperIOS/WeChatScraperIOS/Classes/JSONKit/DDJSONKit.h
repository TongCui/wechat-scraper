//
//  DDJSONKit.h
//  PAPA
//
//  Created by g.zhao on 13-4-2.
//  Copyright (c) 2013年 diandian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDJSONKit : NSObject

+ (id)objectFromJSONString:(NSString *)responseString;
+ (id)objectFromJSONData:(NSData *)responseDate;
+ (id)objectFromJSONData:(NSData *)responseDate withError:(NSError **)error;

+ (NSData*)JSONDataFromObject:(id)object;

@end


@interface NSString (JSONKitSerializing)

- (NSString *)JSONString;
- (NSData *)JSONData;

@end

@interface NSArray (JSONKitSerializing)

- (NSString *)JSONString;
- (NSString *)JSONStringWithTrim:(BOOL)trim;
- (NSData *)JSONData;

@end

@interface NSDictionary (JSONKitSerializing)

- (NSString *)JSONString;
- (NSString *)JSONStringWithTrim:(BOOL)trim;
- (NSData *)JSONData;

@end


@interface NSData (JSONKitDeserializing)

- (id)objectFromJSONData;

@end
