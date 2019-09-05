//
//  UIImage+Swizzle.h
//  SimpleMonkey
//
//  Created by tcui on 14/7/15.
//  Copyright (c) 2015 LuckyTR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Swizzle)

+ (UIImage *)swizzle_imageNamed:(NSString *)name;

@end
