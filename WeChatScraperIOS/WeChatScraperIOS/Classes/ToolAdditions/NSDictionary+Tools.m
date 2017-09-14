//
//  NSDictionary+Tools.m
//  PMP
//
//  Created by Tong on 06/03/2014.
//  Copyright (c) 2014 LuckyTR. All rights reserved.
//

#import "NSDictionary+Tools.h"

@implementation NSDictionary (Tools)

- (id)objectForSafeKey:(id)aKey {
    if (nil == aKey) {
        return nil;
    }
    
    id object = [self objectForKey:aKey];
    
    if ([object isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    return object;
}

- (id)objectForSafeKey:(id)aKey defaultValue:(id)value {
    id object = [self objectForSafeKey:aKey];
    if (nil == object) {
        object = value;
    }
    return object;
}


@end

@implementation NSMutableDictionary (Tools)

- (void)setSafeObject:(id)anObject forKey:(id <NSCopying>)aKey {
    if (nil != aKey && nil != anObject) {
        [self setObject:anObject forKey:aKey];
    }
}

@end

@implementation NSDictionary (TWebService)

- (unsigned long long)responseHeaderContentLength {
    return [[self objectForSafeKey:@"Content-Length"] longLongValue];
}

- (NSString *)responseHeaderContentType {
    return [self objectForSafeKey:@"Content-Type"];
}

@end