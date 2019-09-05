//
//  UIImage+Tools.h
//  SimpleMonkey
//
//  Created by tcui on 14/7/15.
//  Copyright (c) 2015 LuckyTR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tools)

@property (nonatomic, copy) NSString *fileNameWithinBundle;

+ (UIImage *)screenshotWithView:(UIView *)view;

@end
