//
//  UIImage+Swizzle.m
//  SimpleMonkey
//
//  Created by tcui on 14/7/15.
//  Copyright (c) 2015 LuckyTR. All rights reserved.
//

#import "UIImage+Swizzle.h"
#import "UIImage+Tools.h"

@implementation UIImage (Swizzle)

+ (UIImage *)swizzle_imageNamed:(NSString *)name {
    UIImage *image = [UIImage swizzle_imageNamed:name];
    image.fileNameWithinBundle = name;
    return image;
}

@end
