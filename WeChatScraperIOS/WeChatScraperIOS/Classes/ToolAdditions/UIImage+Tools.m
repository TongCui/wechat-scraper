//
//  UIImage+Tools.m
//  SimpleMonkey
//
//  Created by tcui on 14/7/15.
//  Copyright (c) 2015 LuckyTR. All rights reserved.
//

#import "UIImage+Tools.h"
#import <objc/runtime.h>

@implementation UIImage (Tools)

- (NSString *)fileNameWithinBundle {
    return (NSString *)objc_getAssociatedObject(self, @"kMT_Image_FileNameWithinBundle");
}

- (void)setFileNameWithinBundle:(NSString *)fileNameWithinBundle {
    objc_setAssociatedObject(self, @"kMT_Image_FileNameWithinBundle", fileNameWithinBundle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


+ (UIImage *)imageFromView:(UIView *)captureView size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    [captureView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return capturedImage;
}


+ (UIImage *)screenshotWithView:(UIView *)view {
    UIImage *image = [[self class] imageFromView:view size:view.bounds.size];
//    image = [image reSize:CGSizeMake(image.size.width / 2.0, image.size.height / 2.0)];
    return image;
}

- (UIImage *)reSize:(CGSize)size {
    return [self scaleToSize:size force:NO];
}

- (UIImage *)scaleToSize:(CGSize)size force:(BOOL)force {
    if (size.width >= self.size.width - 2 && size.width <= self.size.width + 2 &&
        size.height >= self.size.height - 2 && size.height <= self.size.height + 2) { // 两个像素的误差
        return self;
    }
    if (size.width >= self.size.width - 2 && size.height >= self.size.height - 2) { // 两个像素的误差
        if (!force) {
            return self;
        }
    }
    CGSize newSize;
    if (size.width/size.height > self.size.width/self.size.height) {
        newSize.width = size.width;
        newSize.height = self.size.height/self.size.width*newSize.width;
    } else {
        newSize.height = size.height;
        newSize.width = self.size.width/self.size.height*newSize.height;
    }
    
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0, 0, ceilf(newSize.width), ceilf(newSize.height))];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
