//
//  NSString+Tools.h
//  PMP
//
//  Created by Tong on 05/03/2014.
//  Copyright (c) 2014 LuckyTR. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (TNetwork)

- (NSURL *)networkURL;
- (NSString *)md5String;
- (NSString *)stringByPercentEscaping;
- (NSString *)stringByPercentEscapingWithLeaveUnescapedString:(NSString *)leaveUnescaped;

- (NSString *)trim;
- (NSString *)trimAllSpace;

@end




