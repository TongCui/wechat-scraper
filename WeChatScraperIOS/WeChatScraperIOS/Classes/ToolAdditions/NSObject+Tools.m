//
//  NSObject+Tools.m
//  PMP
//
//  Created by Tong on 06/03/2014.
//  Copyright (c) 2014 LuckyTR. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+Tools.h"
#import "DDBaseItem.h"

@implementation NSObject (Tools)

- (void)pass {

}

+ (NSArray *)allProperties {
    Class selfClass = [self class];
    NSMutableArray * propertyNames = [NSMutableArray array];
    while ([NSObject class] != selfClass) {
        unsigned int propertyCount = 0;
        objc_property_t * allProperties = class_copyPropertyList(selfClass, &propertyCount);
        
        for (unsigned int i = 0; i < propertyCount; ++i) {
            objc_property_t property = allProperties[i];
            const char * name = property_getName(property);
            [propertyNames addObject:[NSString stringWithUTF8String:name]];
        }
        free(allProperties);
        selfClass = class_getSuperclass(selfClass);
    }
    return propertyNames;
}

+ (NSArray *)selfProperties {
    Class selfClass = [self class];
    NSMutableArray * propertyNames = [NSMutableArray array];

    unsigned int propertyCount = 0;
    objc_property_t * allProperties = class_copyPropertyList(selfClass, &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = allProperties[i];
        const char * name = property_getName(property);
        [propertyNames addObject:[NSString stringWithUTF8String:name]];
    }
    free(allProperties);

    return propertyNames;
}

+ (NSString *)propertyType:(NSString *)propertyName {
    objc_property_t aproperty = class_getProperty([self class], [propertyName cStringUsingEncoding:NSASCIIStringEncoding]);
    if (aproperty) {
        char * property_type_attribute = property_copyAttributeValue(aproperty, "T");
        NSString *result = [NSString stringWithUTF8String:property_type_attribute];
        free(property_type_attribute);
        return result;
    }

    return nil;
}

+ (NSArray *)allMethods {
    Class selfClass = [self class];
    NSMutableArray * res = [NSMutableArray array];
    while ([NSObject class] != selfClass) {
        int unsigned numMethods;
        Method *methods = class_copyMethodList(selfClass, &numMethods);
        for (NSUInteger i = 0; i < numMethods; i++) {
            [res addObject:NSStringFromSelector(method_getName(methods[i]))];
        }
        selfClass = class_getSuperclass(selfClass);
    }
    return res;
}

+ (NSArray *)selfMethods {
    NSMutableArray *res = [NSMutableArray array];
    
    int unsigned numMethods;
    Method *methods = class_copyMethodList([self class], &numMethods);
    for (NSUInteger i = 0; i < numMethods; i++) {
        [res addObject:NSStringFromSelector(method_getName(methods[i]))];
    }
    
    return res;
}




@end
