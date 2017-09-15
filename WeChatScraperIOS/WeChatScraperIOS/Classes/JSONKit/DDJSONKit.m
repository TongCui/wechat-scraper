//
//  DDJSONKit.m
//  PAPA
//
//  Created by g.zhao on 13-4-2.
//  Copyright (c) 2013年 diandian. All rights reserved.
//

#import "DDJSONKit.h"

@implementation DDJSONKit

+ (id)objectFromJSONString:(NSString *)jsonString {
    if (jsonString == nil){
		return nil;
	}
	NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
	return [[self class] objectFromJSONData:jsonData withError:nil];
}

+ (id)objectFromJSONData:(NSData*)jsonData {
    return [[self class] objectFromJSONData:jsonData withError:nil];
}

+ (id)objectFromJSONData:(NSData*)jsonData withError:(NSError **)error{
    if (jsonData == nil) {
		return nil;
	}
	
	id data = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:error];
	if (data != nil){
		return data;
	}else{
		NSLog(@"ObjectFromJSONData  is error :  %@", *error);
		return nil;
	}
}


+ (NSData *)JSONDataFromObject:(id)object {
	if (![NSJSONSerialization isValidJSONObject:object]) {
		return nil;
	}
	
	NSError *error = nil;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
	if ([jsonData length] > 0 && error == nil){
		return jsonData;
	}else{
		NSLog(@"JSONDataFromObject is error  %@",error);
		return nil;
	}
}

+ (NSString *)JSONString:(id)object {
    return [[self class] JSONString:object trim:YES];
}

+ (NSString *)JSONString:(id)object trim:(BOOL)trim {
	if (![NSJSONSerialization isValidJSONObject:object]) {
        NSLog(@"JSON is not valid!!!");
		return nil;
	}
	
	NSError *error = nil;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:trim ? 0 : NSJSONWritingPrettyPrinted error:&error];
	if ([jsonData length] > 0 && error == nil){
		return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
	}else{
		NSLog(@"JSONString is error  %@",error);
		return nil;
	}
}


@end


@implementation NSString (JSONKitSerializing)
- (NSString *)JSONString{
	return [DDJSONKit JSONString:self];
}
- (NSData *)JSONData{
	return [DDJSONKit JSONDataFromObject:self];
}
@end

@implementation NSArray (JSONKitSerializing)

- (NSString *)JSONString{
	return [DDJSONKit JSONString:self];
}

- (NSString *)JSONStringWithTrim:(BOOL)trim {
    return [DDJSONKit JSONString:self trim:trim];
}

- (NSData *)JSONData{
	return [DDJSONKit JSONDataFromObject:self];
}
@end

@implementation NSDictionary (JSONKitSerializing)

- (NSString *)JSONString{
	return [DDJSONKit JSONString:self];
}

- (NSString *)JSONStringWithTrim:(BOOL)trim {
    return [DDJSONKit JSONString:self trim:trim];
}

- (NSData *)JSONData{
	return [DDJSONKit JSONDataFromObject:self];
}
@end

@implementation NSData (JSONKitDeserializing)
- (id)objectFromJSONData{
	return [DDJSONKit objectFromJSONData:self];
}
@end
