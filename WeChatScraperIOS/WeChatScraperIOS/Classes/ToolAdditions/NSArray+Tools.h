//
//  NSArray+Tools.h
//  PMP
//
//  Created by Tong on 05/03/2014.
//  Copyright (c) 2014 LuckyTR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Tools)

- (void)perform:(SEL)selector;
- (void)perform:(SEL)selector withObject:(id)p1;
- (void)perform:(SEL)selector withObject:(id)p1 withObject:(id)p2;

- (id)previourWithObject:(id)object;
- (id)nextWithObject:(id)object;
- (id)objectAtSafeIndex:(NSUInteger)index;

- (NSArray *)randomOrderArray;
- (NSArray *)sortedArray;
- (id)randomObject;


@end

@interface NSMutableArray (Tools)

- (void)reverse;
- (void)addSafeObject:(id)object;
- (void)insertSafeObject:(id)object atIndex:(NSUInteger)index;

@end

@interface NSArray (Debug)

- (NSArray *)arrayWithEnlarge;
- (NSArray *)arrayWithEnlargeSize:(NSUInteger)size;

@end
