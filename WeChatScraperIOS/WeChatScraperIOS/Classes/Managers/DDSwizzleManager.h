//
//  DDSwizzleManager.h
//  Songshuwo
//
//  Created by tcui on 30/4/15.
//  Copyright (c) 2015 Tong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDSwizzleManager : NSObject

+(instancetype)sharedInstance;

- (void)swizzleMethods;
- (void)swizzleInstanceMethodWithClass:(Class)class originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;
- (void)swizzleClassMethodWithClass:(Class)class originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;

@end
