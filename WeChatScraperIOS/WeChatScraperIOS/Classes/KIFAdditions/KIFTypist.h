//
//  KIFTypist.h
//  KIF
//
//  Created by Pete Hodgson on 8/12/12.
//
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KIFTypist : NSObject
+ (UIWindow *) keyboardWindow;
+ (BOOL)enterCharacter:(NSString *)characterString;
+ (BOOL)enterText:(NSString *)text;
+ (void) cancelAnyInitialKeyboardShift;
@end
