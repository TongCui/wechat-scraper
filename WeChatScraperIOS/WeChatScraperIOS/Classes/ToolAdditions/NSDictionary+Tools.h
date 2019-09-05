//
//  NSDictionary+Tools.h
//  PMP
//
//  Created by Tong on 06/03/2014.
//  Copyright (c) 2014 LuckyTR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Tools)

- (id)objectForSafeKey:(id)aKey;
- (id)objectForSafeKey:(id)aKey defaultValue:(id)value;

@end

@interface NSMutableDictionary (Tools)

- (void)setSafeObject:(id)anObject forKey:(id <NSCopying>)aKey;

@end

@interface NSDictionary (TWebService)

- (unsigned long long)responseHeaderContentLength;
- (NSString *)responseHeaderContentType;

@end

