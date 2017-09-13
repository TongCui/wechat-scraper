//
//  DDSwizzleManager.m
//  Songshuwo
//
//  Created by tcui on 30/4/15.
//  Copyright (c) 2015 Tong. All rights reserved.
//

#import "DDSwizzleManager.h"
#import <objc/runtime.h>
#import "UIViewController+Swizzle.h"
#import "UIImage+Swizzle.h"
#import "UIApplication+Swizzle.h"

@implementation DDSwizzleManager

#pragma mark - Life cycle
+(instancetype)sharedInstance {
    static DDSwizzleManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[DDSwizzleManager alloc] init];
        
    });
    return _sharedInstance;
}

#pragma mark - Init
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)swizzleMethods {
    
#ifdef DEMO
    [self swizzleInstanceMethodWithClass:[UIViewController class] originalSelector:@selector(viewDidAppear:) swizzledSelector:@selector(swizzle_viewDidAppear:)];
//    [self swizzleInstanceMethodWithClass:[UIApplication class] originalSelector:@selector(sendEvent:) swizzledSelector:@selector(swizzle_sendEvent:)];
#endif
    
    [self swizzleClassMethodWithClass:[UIImage class] originalSelector:@selector(imageNamed:) swizzledSelector:@selector(swizzle_imageNamed:)];
}

#pragma mark - Swizzling
- (void)swizzleInstanceMethodWithClass:(Class)class originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    //  YES if the method was added successfully, otherwise NO (for example, the class already contains a method implementation with that name).
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)swizzleClassMethodWithClass:(Class)class originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    Method originalMethod = class_getClassMethod(class, originalSelector);
    Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
    
    class = object_getClass((id)class);
    
    //  YES if the method was added successfully, otherwise NO (for example, the class already contains a method implementation with that name).
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


@end
