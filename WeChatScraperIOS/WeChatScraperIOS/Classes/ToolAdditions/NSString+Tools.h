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

@interface NSString (TPath)

#define DOCUMENTS_FOLDER    ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0])
#define CACHES_FOLDER       ([NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0])

+ (NSString *)filePathOfDocumentFolderWithName:(NSString *)fileName;
+ (NSString *)filePathOfDocumentFolderWithFolder:(NSString *)folderName fileName:(NSString *)fileName;
+ (NSString *)filePathOfCachesFolderWithName:(NSString *)fileName;
+ (NSString *)filePathOfCachesFolderWithFolder:(NSString *)folderName fileName:(NSString *)fileName;

@end




