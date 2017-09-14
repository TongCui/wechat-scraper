//
//  NSArray+Tools.m
//  PMP
//
//  Created by Tong on 05/03/2014.
//  Copyright (c) 2014 LuckyTR. All rights reserved.
//

#import "NSArray+Tools.h"
#import "Global.h"

@implementation NSArray (Tools)

- (void)perform:(SEL)selector {
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SuppressPerformSelectorLeakWarning([obj performSelector:selector]);
    }];
}

- (void)perform:(SEL)selector withObject:(id)p1 {
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SuppressPerformSelectorLeakWarning([obj performSelector:selector withObject:p1]);
    }];
}

- (void)perform:(SEL)selector withObject:(id)p1 withObject:(id)p2 {
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SuppressPerformSelectorLeakWarning([obj performSelector:selector withObject:p1 withObject:p2]);
    }];
}

- (id)previourWithObject:(id)object {
    NSInteger objectIndex = [self indexOfObject:object];
    if (NSNotFound == objectIndex) {
        return nil;
    }
    
    return objectIndex > 0 ? [self objectAtIndex:objectIndex - 1] : nil;
}

- (id)nextWithObject:(id)object {
    NSInteger totalCount = [self count];
    NSInteger objectIndex = [self indexOfObject:object];
    if (NSNotFound == objectIndex) {
        return nil;
    }
    
    return objectIndex < totalCount - 1 ? [self objectAtIndex:objectIndex + 1] : nil;
}

- (id)objectAtSafeIndex:(NSUInteger)index {
    if ([self count] > index) {
        return [self objectAtIndex:index];
    }
    return nil;
}


- (NSArray *)randomOrderArray {
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self];
    NSUInteger count = [mutableArray count];
    if (count > 1) {
        for (NSUInteger i = count - 1; i > 0; --i) {
            [mutableArray exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform((int32_t)(i + 1))];
        }
    }
    
    return mutableArray;
}

- (NSArray *)sortedArray {
    return [self sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (id)randomObject {
    NSInteger idx = arc4random_uniform((int32_t)(self.count));
    
    return [self objectAtSafeIndex:idx];
}

@end

@implementation NSMutableArray (LBAdditions)

- (void)reverse {
    if ([self count] == 0)
        return;
    NSUInteger i = 0;
    NSUInteger j = [self count] - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:j];
        
        i++;
        j--;
    }
}

- (void)addSafeObject:(id)object {
    if (nil != object) {
        [self addObject:object];
    }
}

- (void)insertSafeObject:(id)object atIndex:(NSUInteger)index {
    if (nil != object && index <= self.count) {
        [self insertObject:object atIndex:index];
    }
}


@end

@implementation NSArray (Debug)

- (NSArray *)arrayWithEnlarge {
    return [self arrayWithEnlargeSize:30];
}

- (NSArray *)arrayWithEnlargeSize:(NSUInteger)size {
    NSArray *res = nil;
    if (self.count > 0) {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSUInteger i = 0; i < 30; i++) {
            [tempArray addObjectsFromArray:self];
        }
        res = tempArray;
    }
    return res;
}

@end

