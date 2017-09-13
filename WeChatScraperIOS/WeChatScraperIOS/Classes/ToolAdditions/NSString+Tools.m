//
//  NSString+Tools.m
//  PMP
//
//  Created by Tong on 05/03/2014.
//  Copyright (c) 2014 LuckyTR. All rights reserved.
//

#import "NSString+Tools.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (TNetwork)

- (NSURL *)networkURL {
    return [NSURL URLWithString:self];
}

- (NSString *)md5String {
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
	return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
}

- (NSString *)stringByPercentEscaping {
    return [self stringByPercentEscapingWithLeaveUnescapedString:nil];
}

- (NSString *)stringByPercentEscapingWithLeaveUnescapedString:(NSString *)leaveUnescaped {
    return  (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, (CFStringRef)leaveUnescaped, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
}


- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)trimAllSpace {
    return  [[self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""];
}


@end
