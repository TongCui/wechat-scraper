//
//  Global.h
//  TypeTest
//
//  Created by tcui on 12/6/15.
//  Copyright (c) 2015 Tong. All rights reserved.
//

#define LOCALMONKEYTEST 1

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

typedef NS_ENUM(NSUInteger, UIVCSenseType) {
    UIVCSenseTypeUnknown,
    UIVCSenseTypeAlert,
    UIVCSenseTypePreLogin,
    UIVCSenseTypeLogin,
    UIVCSenseTypeFullScreenWebPage,
    UIVCSenseTypeLoginWaiting,
    UIVCSenseTypeWebLoginWaiting,
    UIVCSenseTypeScroll,
    UIVCSenseTypeHuman,
    UIVCSenseTypeMonkey,
};

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


#define SuppressWeakSelfLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wignored-attributes\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


#define TO_CSTR(id)				[[NSString stringWithFormat:@"%@", id] cStringUsingEncoding:NSUTF8StringEncoding]

static NSInteger WFGrid = 10;
//static NSInteger map[1000][1000];
//static NSInteger mX,mY;

#define kBundleId	([[NSBundle mainBundle] bundleIdentifier])

#define kScreenWidth    ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight   ([UIScreen mainScreen].bounds.size.height)



#define DDLog(s,...) NSLog(@"[%@(%d)] !!!%@",[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__]);

#define CACHES_FOLDER       ([NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0])
