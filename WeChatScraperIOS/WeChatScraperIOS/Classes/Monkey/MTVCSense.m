//
//  UIVCSense.m
//  TypeTest
//
//  Created by tcui on 16/6/15.
//  Copyright (c) 2015 Tong. All rights reserved.
//

#import "MTVCSense.h"
#import "Global.h"
#import <UIKit/UIKit.h>
#import "UIApplication+Tools.h"
#import "MTAutomationBridge.h"
#import "MTMonkeyTestManager.h"
#import "MTGridWindow.h"
#import "MTSenseLog.h"
#import "CGGeometry-KIFAdditions.h"
#import "UIView+Tools.h"
#import "UIImage+Tools.h"
#import "NSString+Tools.h"
#import "UIViewController+Tools.h"
#import "MTSenseOperation.h"


#define kMT_JS_INPUT_NORMAL      (@"document.querySelectorAll(\"input[type=text],input[type=search],input[type=email]\")")
#define kMT_JS_INPUT_PASSWORD    (@"document.querySelectorAll(\"input[type=password]\")")

#define kMT_Sense_MAX_Duration_Count    (8)

@interface UIWindow (Private)
+(id)keyWindow;
+(id)_findWithDisplayPoint:(CGPoint)displayPoint;
@end


@interface MTVCSense ()

@property (nonatomic, assign) NSUInteger automationCount;

@end

@implementation MTVCSense

#pragma mark - Accessors
- (NSArray *)allViews {
    return [self.viewHashTable allObjects];
}

- (void)setType:(UIVCSenseType)type {
    if (type != _type) {
        self.automationCount = 0;
        _type = type;
    }
}

- (void)setAutomationCount:(NSUInteger)automationCount {
    _automationCount = automationCount;
    
    if (self.type != UIVCSenseTypeMonkey && automationCount > kMT_Sense_MAX_Duration_Count) {
        self.type = UIVCSenseTypeMonkey;
    }
    
    if (self.type == UIVCSenseTypeMonkey && automationCount > kMT_Sense_MAX_Duration_Count) {
        self.duration = -1;
        [[MTMonkeyTestManager sharedInstance] updateLogWithSense:self];
    }
}

#pragma mark - Life cycle

+ (instancetype)currentSense {
    MTVCSense *sense = [[MTVCSense alloc] init];

    return sense;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.viewHashTable = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
        
        self.alertTapableViews = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
        self.preloginTapableViews = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
        self.importantTapableViews = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
        self.tapableViews = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
        
        self.textFields = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
        self.fullScreenWebViews = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
        self.scrollViews = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
        
        NSMutableSet *viewControllerNames = [NSMutableSet set];

        NSUInteger maxX = [UIScreen mainScreen].bounds.size.width / WFGrid;
        NSUInteger maxY = [UIScreen mainScreen].bounds.size.height / WFGrid;
        for (NSUInteger x = 0; x < maxX; x++) {
            for (NSUInteger y = 0; y < maxY; y++){
                CGPoint automationPoint = CGPointMake(x*WFGrid + WFGrid / 2,y*WFGrid + WFGrid / 2);
                UIWindow *window = [UIWindow _findWithDisplayPoint:automationPoint];

                id hitObject = [window hitTest:automationPoint withEvent:nil];
//                NSLog(@"Raw==========%@",[[hitObject class] description]);
                if (hitObject) {
                    if ([[[hitObject class] description] localizedCaseInsensitiveContainsString:@"keyboard"]) {
                        self.keyboardShown = YES;
                        continue;
                    }
                    
                    if (![self.viewHashTable containsObject:hitObject]) {
                        [self addTargetView:hitObject];
                    }
                    
                    UIViewController *vc = [(UIView *)hitObject viewController];
                    
                    if (vc.monkeyTestDisabled) {
                        self.containsDisabledViewController = YES;
                    }
                    NSString *name = [vc description];
                    if (name && ![name containsString:@"UIInputWindowController"]) {
                        [viewControllerNames addObject:name];
                    }
                    
                }
            }
        }
        
        self.viewControllerNames = viewControllerNames;
        
        [self detectSenseType];
        
//        [UIApplication sharedApplication].monkeytestDebug = YES;
        if ([UIApplication sharedApplication].monkeytestDebug) {
            DDLog(@"=========Debug Info");
            DDLog(@"===vc names ==\n%@ \n", self.viewControllerNames);
            DDLog(@"===all ==\n%@ \n", self.allViews);
            DDLog(@"===alertTapableViews ==\n%@ \n", self.alertTapableViews);
            DDLog(@"===preloginTapableViews ==\n%@ \n", self.preloginTapableViews);
            DDLog(@"===importantTapableViews ==\n%@ \n", self.importantTapableViews);
            DDLog(@"===tapableViews ==\n%@ \n", self.tapableViews);
            DDLog(@"===textFields ==\n%@ \n", self.textFields);
            DDLog(@"===fullScreenWebViews ==\n%@ \n", self.fullScreenWebViews);
            DDLog(@"===scrollableViews ==\n%@ \n", self.scrollViews);
            
            //  find ./ -name 'Global.h'|xargs cat| tr -d ' '|egrep 'UIVCSenseType\w+,'|awk -F ',' '{print "@\""$1"\""}'|tr '\n' ','
            NSArray *array = @[@"UIVCSenseTypeUnknown",@"UIVCSenseTypeAlert",@"UIVCSenseTypePreLogin",@"UIVCSenseTypeLogin",@"UIVCSenseTypeFullScreenWebPage",@"UIVCSenseTypeLoginWaiting",@"UIVCSenseTypeWebLoginWaiting",@"UIVCSenseTypeScroll",@"UIVCSenseTypeHuman",@"UIVCSenseTypeMonkey"];
            DDLog(@"===SenseType %@ ==", array[self.type]);
            
        }
        
        self.startTime = [NSDate date];
        self.operations = [NSMutableArray array];
    }
    return self;
}

#pragma mark - HitTest


- (void)addTargetView:(id)hitObject {
    [self.viewHashTable addObject:hitObject];
    
    //  We Just Ignore UITableViewLabel of non-custom table cell
    if ([hitObject isKindOfClass:[NSClassFromString(@"UITableViewLabel") class]]) {
        return;
    }
    
    //  Alert Views which should tap the very first.
    if ([hitObject isKindOfClass:[NSClassFromString(@"_UIAlertControllerActionView") class]]) {
        [self.alertTapableViews addObject:hitObject];
        return;
    }
    
    //  Find Web View
    if ([hitObject isKindOfClass:[NSClassFromString(@"UIWebBrowserView") class]]) {
        UIView *currentView = (UIView *)hitObject;
        UIView *superView = nil;
        UIWebView *targetWebView = nil;
        while (currentView.superview) {
            superView = currentView.superview;
            if ([superView isKindOfClass:[UIWebView class]]) {
                targetWebView = (UIWebView *)superView;
                break;
            }
            
            currentView = superView;
        }
        
        if (targetWebView && targetWebView.ratioOfFrameOccupiedInWindow > 0.7) {
            [self.fullScreenWebViews addObject:targetWebView];
            return;
        }
    }
    
    //  TextField
    if ([hitObject isKindOfClass:[UITextField class]]) {
        [self.textFields addObject:hitObject];
        return;
    }
    
    //  TableCell
    if ([hitObject isKindOfClass:[NSClassFromString(@"UITableViewCellContentView") class]]) {
        
        //  TableView
        UIView *targetview = [hitObject superview];
        while (![targetview isKindOfClass:[UITableView class]]) {
            targetview = targetview.superview;
        }
        UITableView *tableView = (UITableView *)targetview;
        if ([targetview isKindOfClass:[UITableView class]] && ![self.scrollViews containsObject:targetview] && (tableView.contentSize.width > tableView.width || tableView.contentSize.height > tableView.height)) {
            [self.scrollViews addObject:tableView];
        }

        __block BOOL isPreloginCell = NO;
        __block BOOL isImportantCell = NO;
        [[hitObject allSubViews] enumerateObjectsUsingBlock:^(UILabel *subview, NSUInteger idx, BOOL *stop) {
            if ([subview isKindOfClass:[UILabel class]]) {
                NSString *labelTitle = [self titleWithLabel:(UILabel *)subview];
                
                if ([self isPreloginButtonWithTitle:labelTitle]) {
                    isPreloginCell = YES;
                    *stop = YES;
                } else if ([self isImportantThingWithText:labelTitle]) {
                    isImportantCell = YES;
                    *stop = YES;
                }
            }
        }];
        
        if (isPreloginCell) {
            [self.preloginTapableViews addObject:hitObject];
            return;
        }
        
        if (isImportantCell) {
            [self.importantTapableViews addObject:hitObject];
            return;
        }
    }
    
    //  Scroll View
    if ([hitObject isKindOfClass:[UIScrollView class]]) {
        
        UIScrollView *scrollView = (UIScrollView *)hitObject;
        if (scrollView.contentSize.width > scrollView.width || scrollView.contentSize.height > scrollView.height) {
            [self.scrollViews addObject:hitObject];
        }
        
        return;
    }
    
    //  Buttons
    if ([hitObject isKindOfClass:[UIButton class]]) {
        NSString *title = [self titleWithButton:(UIButton *)hitObject];
        
        if ([self isPreloginButtonWithTitle:title]) {
            [self.preloginTapableViews addObject:hitObject];
            return;
        }
        
        if ([self isImportantThingWithText:title]) {
            [self.importantTapableViews addObject:hitObject];
            return;
        }
    }
    
    //  Label
    if ([hitObject isKindOfClass:[UILabel class]] && [(UILabel *)hitObject gestureRecognizers].count > 0) {
        NSString *title = [self titleWithLabel:(UILabel *)hitObject];
        
        if ([self isPreloginButtonWithTitle:title]) {
            [self.preloginTapableViews addObject:hitObject];
            return;
        }
        
        if ([self isImportantThingWithText:title]) {
            [self.importantTapableViews addObject:hitObject];
            return;
        }
    }
    
    //  UIView
    /*
    if ([hitObject isKindOfClass:[UIView class]]) {
        __block BOOL swipeGesture = NO;
        [[(UIView *)hitObject gestureRecognizers] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[UISwipeGestureRecognizer class]]) {
                swipeGesture = YES;
                *stop = YES;
            }
        }];
        
        if (swipeGesture) {
            NSLog(@"swipeGesture %@", hitObject);
            [self.scrollableViews addObject:hitObject];
        }
        
        return;
    }
     */
    
    //DDLog(@"Left Things %@", hitObject);
    
    [self.tapableViews addObject:hitObject];
}

#pragma mark - UI Logic

- (NSString *)titleWithButton:(UIButton *)button {
    NSString *title = [button currentTitle];
    if (nil == title) {
        title = [[button currentAttributedTitle] string];
    }
    if (nil == title) {
        title = [button currentImage].fileNameWithinBundle;
    }
    
    return title;
}

- (NSString *)titleWithLabel:(UILabel *)label {
    NSString *title = label.text;
    
    if (nil == title) {
        title = [label.attributedText string];
    }
    
    return title;
}

- (NSArray *)untappedViewWithArray:(NSArray *)array {
    NSMutableArray *res = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if (!view.tapped) {
            [res addObject:view];
        }
    }];
    return res;
}

static NSArray *importantKeywords = nil;
- (BOOL)isImportantThingWithText:(NSString *)text {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *array = [@[@"register", @"sign up", @"skip", @"close", @"done", @"back", @"accepte", @"agree", @"next"] mutableCopy];
        
        importantKeywords = [array copy];
    });
    
    return [self containsText:text withinKeywords:importantKeywords];
}

static NSArray *preloginKeywords = nil;
- (BOOL)isPreloginButtonWithTitle:(NSString *)text {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *array = [@[@"log in", @"sign in", @"login", @"continue"] mutableCopy];
        
        if (![kBundleId containsString:@"facebook"]) {
            [array addObject:@"facebook"];
        }
        
        if (![kBundleId containsString:@"twitter"]) {
            [array addObject:@"twitter"];
        }
        
        preloginKeywords = [array copy];
    });
    
    return [self containsText:text withinKeywords:preloginKeywords];
}

- (BOOL)containsText:(NSString *)text withinKeywords:(NSArray *)keywords {
    if (nil == text) {
        return NO;
    }
    
    __block BOOL res = NO;
    [keywords enumerateObjectsUsingBlock:^(NSString *keyword, NSUInteger idx, BOOL *stop) {
        if ([text localizedCaseInsensitiveContainsString:keyword]) {
            res = YES;
            *stop = YES;
        }
    }];
    
    return res;
}

#pragma mark - Sense

- (void)detectSenseType {
    //  Alert First
    if (self.alertTapableViews.count > 0) {
        self.type = UIVCSenseTypeAlert;
        return;
    }
    
    //  Password TextField
    if (self.textFields.count > 0) {
        __block BOOL containsPassword = NO;
        
        [[self.textFields allObjects] enumerateObjectsUsingBlock:^(UITextField *textField, NSUInteger idx, BOOL *stop) {
            if (textField.secureTextEntry) {
                containsPassword = YES;
                *stop = YES;
            }
        }];
        
        if (containsPassword) {
            self.type = UIVCSenseTypeLogin;
            return;
        }
    }

    //  WebView with password input
    if (self.fullScreenWebViews.count > 0) {
        __block BOOL fullScreen = NO;
        
        [[self.fullScreenWebViews allObjects] enumerateObjectsUsingBlock:^(UIWebView *webView, NSUInteger idx, BOOL *stop) {
            if (webView.ratioOfFrameOccupiedInWindow > 0.7) {
                fullScreen = YES;
                *stop = YES;
            }
            
        }];
        
        if (fullScreen) {
            self.type = UIVCSenseTypeFullScreenWebPage;
            return;
        }
    }
    
    if (self.preloginTapableViews.count > 0) {
        self.type = UIVCSenseTypePreLogin;
        return;
    }
    
    if (self.scrollViews.count > 0) {
        self.type = UIVCSenseTypeScroll;
        return;
    }
    
    //  Default
    self.type = UIVCSenseTypeHuman;
}

- (BOOL)isEqualToSense:(MTVCSense *)sense {
    if (nil == sense) {
        return NO;
    }
    
    NSMutableSet *diffSet = nil;
    if (self.viewControllerNames > sense.viewControllerNames) {
        diffSet = [self.viewControllerNames mutableCopy];
        [diffSet minusSet:sense.viewControllerNames];
    } else {
        diffSet = [sense.viewControllerNames mutableCopy];
        [diffSet minusSet:self.viewControllerNames];
    }
    
    if ([diffSet count] > 0) {
        DDLog(@"New Sense");
        DDLog(@"%@", self.viewControllerNames)
        DDLog(@"%@", sense.viewControllerNames);
        DDLog(@"==========");
    }
    
    return [diffSet count] == 0;
}

- (void)copyUIElementsFromSense:(MTVCSense *)sense {
    self.viewHashTable = sense.viewHashTable;
    
    self.alertTapableViews = sense.alertTapableViews;
    self.preloginTapableViews = sense.preloginTapableViews;
    self.importantTapableViews = sense.importantTapableViews;
    self.tapableViews = sense.tapableViews;
    
    self.textFields = sense.textFields;
    self.fullScreenWebViews = sense.fullScreenWebViews;
    self.scrollViews = sense.scrollViews;
    
    self.keyboardShown = sense.keyboardShown;
}

#pragma mark - Automation

- (void)doAutomation {
    if (self.containsDisabledViewController) {
        DDLog(@"Monkey Test Disabled for this Sense...");
        return;
    }
    
    if (self.doingAutomation) {
        [self.operations addObject:[MTSenseLog watingLogWithSenseType:self.type]];
        DDLog(@"Doing Animation...");
        return;
    }
    
    self.automationCount ++;
    DDLog(@"Automation Count :(%ld)", (long)self.automationCount);
    
    NSLog(@"============");
    switch (self.type) {
        case UIVCSenseTypeAlert:
            [self doAlertTap];
            return;
        case UIVCSenseTypePreLogin:
            [self doPreLogin];
            break;
        case UIVCSenseTypeLogin:
            [self doLogin];
            break;
        case UIVCSenseTypeFullScreenWebPage:
            [self doWebLogin];
            break;
        case UIVCSenseTypeLoginWaiting:
            [self doLoginWaiting];
            break;
        case UIVCSenseTypeWebLoginWaiting:
            [self doWebLoginWaiting];
            break;
        case UIVCSenseTypeScroll:
            [self doScroll];
            break;
        case UIVCSenseTypeHuman:
            [self doHumanTap];
            break;
        case UIVCSenseTypeMonkey:
            [self doMonkeyTap];
            break;
        
        default:
            DDLog(@"Default!!");
            break;
    }
}

#pragma mark - Operations

#pragma mark - AlertTap

- (void)doAlertTap {
    DDLog(@"=============doAlertTap...")
    if (self.alertTapableViews.count == 0) {
        return;
    }
    
    NSArray *views = [self untappedViewWithArray:[self.alertTapableViews allObjects]];
    [self tapRandomViewWithViews:views];
}

#pragma mark - Login

- (void)doLogin {
    DDLog(@"=============doLogin...");
    
    self.doingAutomation = YES;
    DDLog(@"password is (%@)", [UIApplication sharedApplication].password);
    DDLog(@"userName is (%@)", [UIApplication sharedApplication].userName);
    
    NSArray *sortedArray = [[self.textFields allObjects] sortedArrayUsingComparator:^NSComparisonResult(UIView *a, UIView *b) {
        
        CGRect aFrame = [a.superview convertRect:a.frame toView:a.window];
        CGRect bFrame = [b.superview convertRect:b.frame toView:b.window];
        
        return [@(aFrame.origin.y) compare:@(bFrame.origin.y)];
    }];
    
    [self fullfillLoginTextFields:sortedArray secureText:[UIApplication sharedApplication].password defaultText:[UIApplication sharedApplication].userName];
}

#pragma mark - Login - TextFields

- (void)fullfillLoginTextFields:(NSArray *)textFields secureText:(NSString *)secureText defaultText:(NSString *)defaultText {
    [self fullfillLoginTextFields:textFields secureText:secureText defaultText:defaultText currentIdx:0];
}

- (void)fullfillLoginTextFields:(NSArray *)textFields secureText:(NSString *)secureText defaultText:(NSString *)defaultText currentIdx:(NSUInteger)currentIdx {
    
    if (currentIdx >= textFields.count) {
        self.doingAutomation = NO;
        self.type = UIVCSenseTypeLoginWaiting;
        [UIApplication sharedApplication].didTryLogin = YES;
        return;
    }
    
    UITextField *textField = [textFields objectAtIndex:currentIdx];
    
    if (!textField.isFirstResponder) {
        [textField becomeFirstResponder];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UITextField *textField = [textFields objectAtIndex:currentIdx];
        DDLog(@"Found TextField %@", textField);
        
        if (textField.text.length > 0) {
            NSMutableString *string = [NSMutableString string];
            for (NSUInteger i = 0; i < textField.text.length; i++) {
                [string appendString:@"\b"];
            }
            [string appendString:@"\b"];
            
            [MTAutomationBridge typeIntoKeyboard:string];
        }
        
        NSString *typeString = nil;
        if (textField.secureTextEntry) {
            typeString = secureText;
        } else if (textField.keyboardType == UIKeyboardTypeNumberPad) {
            if (textField.width <= 80) {
                typeString = @"86\n";
            } else {
                typeString = @"13900000000\n";
            }
        } else {
            typeString = defaultText;
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginTextFieldsKeyboardInputDone:) name:@"kMT_keyboardInputDone" object:nil];
        
        [self.operations addObject:[MTSenseLog typeLogWithSenseType:self.type string:typeString]];
        [MTAutomationBridge typeIntoKeyboard:typeString userInfo:@{@"params":@[textFields, secureText, defaultText, @(currentIdx + 1)]}];
        
    });
}

- (void)loginTextFieldsKeyboardInputDone:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kMT_keyboardInputDone" object:nil];
    NSArray *params = notification.userInfo[@"params"];
    
    [self fullfillLoginTextFields:params[0] secureText:params[1] defaultText:params[2] currentIdx:[params[3] unsignedIntegerValue]];
}

#pragma mark - WebLogin

- (void)doWebLogin {
    DDLog(@"=============doWebLogin...");
    UIWebView *webView = [[self.fullScreenWebViews allObjects] firstObject];
    webView.keyboardDisplayRequiresUserAction = NO;
    
    if ([kBundleId isEqualToString:@"com.netflix.Netflix"]) {
        [self typeIntoWebViewNetflix:webView];
    } else {
        [self typeIntoWebView:webView];
    }
}

- (void)typeIntoWebView:(UIWebView *)webView {

}

- (void)webTextFieldsKeyboardInputDone:(NSNotification *)notification {
    DDLog(@"Notification webTextFieldsKeyboardInputDone recieved...");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kMT_keyboardInputDone" object:nil];
    UIWebView *webView = notification.userInfo[@"webView"];
    
    [self typeIntoWebView:webView];
}

#pragma mark - WebLogin - Exception

- (void)typeIntoWebViewNetflix:(UIWebView *)webView {
    //  TODO Later
}

#pragma mark - PreLogin
- (void)doPreLogin {
    DDLog(@"=============doPreLogin...");
    __block UIView *targetView = nil;
    __block NSString *targetKeyword = nil;
    NSArray *views = [self.preloginTapableViews allObjects];
    
    [preloginKeywords enumerateObjectsUsingBlock:^(NSString *keyword, NSUInteger idx, BOOL *stop) {
        [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop1) {
            //  TableView
            if ([view isKindOfClass:[NSClassFromString(@"UITableViewCellContentView") class]]) {
                [[view allSubViews] enumerateObjectsUsingBlock:^(UILabel *subview, NSUInteger idx, BOOL *stop2) {
                    if ([subview isKindOfClass:[UILabel class]]) {
                        NSString *labelTitle = [self titleWithLabel:(UILabel *)subview];
                        if ([labelTitle localizedCaseInsensitiveContainsString:keyword] && !view.tapped) {
                            targetView = view;
                            targetKeyword = keyword;
                            *stop = YES;
                            *stop1 = YES;
                            *stop2 = YES;
                        }
                    }
                }];
            }
            //  Label
            NSString *title = nil;
            if ([view isKindOfClass:[UILabel class]]) {
                title = [self titleWithLabel:(UILabel *)view];
            } else if ([view isKindOfClass:[UIButton class]]) {
                title = [self titleWithButton:(UIButton *)view];
            }
            
            if ([title localizedCaseInsensitiveContainsString:keyword] && !view.tapped) {
                targetView = view;
                targetKeyword = keyword;
                *stop = YES;
            }
            
        }];
    }];
    
    DDLog(@"Found %@(%@)...", targetView, targetKeyword);
    if (targetView) {
        
        [self.operations addObject:[MTSenseLog pointLogWithSenseType:self.type point:targetView.mainWindowPoint]];
        [MTAutomationBridge tapView:targetView];
    } else {
        [self doHumanTap];
    }
}

#pragma mark - Waitings
- (void)doLoginWaiting {
    DDLog(@"=============doLoginWaiting...");
    if (self.automationCount > 3) {
        self.type = UIVCSenseTypePreLogin;
        [self doPreLogin];
    }
}

- (void)doWebLoginWaiting {
    DDLog(@"=============doWebLoginWaiting...");
}


#pragma mark - Scroll
- (void)doScroll {
    NSArray *uptappedView = [self untappedViewWithArray:[self.scrollViews allObjects]];
    
    if (uptappedView.count != 0) {
        UIScrollView *scrollView = [uptappedView firstObject];
        
        if (scrollView.contentSize.width > scrollView.width * 1.4f) {
            [self.operations addObject:[MTSenseLog swipeLogWithSenseType:self.type point:scrollView.mainWindowPoint]];
            [MTAutomationBridge swipeView:scrollView inDirection:PADirectionLeft];
        } else if (scrollView.contentSize.height > scrollView.height * 1.4f) {
            [self.operations addObject:[MTSenseLog swipeLogWithSenseType:self.type point:scrollView.mainWindowPoint]];
            [MTAutomationBridge swipeView:scrollView inDirection:PADirectionUp];
        }
        
    } else {
        self.type = UIVCSenseTypeHuman;
    }
}

#pragma mark - Human Tap

- (void)doHumanTap {
    DDLog(@"=============doHumanTap");
    
    if (self.keyboardShown) {
        __block UITextField *textField = nil;
        [[self.textFields allObjects] enumerateObjectsUsingBlock:^(UITextField *obj, NSUInteger idx, BOOL *stop) {
            if (obj.isFirstResponder) {
                textField = obj;
            }
        }];
        
        if (nil != textField) {
            NSString *typeString = @"monkey\n";
            
            if (textField.keyboardType == UIKeyboardTypeNumberPad) {
                if (textField.width <= 80) {
                    typeString = @"86\n";
                } else {
                    typeString = @"13900000000\n";
                }
            }
            
            DDLog(@"TextField %@ - (%@)", typeString, textField.text);
            
            if (![typeString containsString:[textField.text trimAllSpace]]) {
                self.doingAutomation = YES;
                if (textField.text.length > 0) {
                    NSMutableString *string = [NSMutableString string];
                    for (NSUInteger i = 0; i < textField.text.length; i++) {
                        [string appendString:@"\b"];
                    }
                    [string appendString:@"\b"];
                    [MTAutomationBridge typeIntoKeyboard:string];
                }
                
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wignored-attributes"
                __weak __typeof(self)weakSelf = self;
#pragma clang diagnostic pop
                [self.operations addObject:[MTSenseLog typeLogWithSenseType:self.type string:typeString]];
                [MTAutomationBridge typeIntoKeyboard:typeString completionBlock:^{
                    weakSelf.doingAutomation = NO;
                }];
                return;
            }
        }
    }
    
    
    NSMutableArray *views = [NSMutableArray array];
    
    [views addObjectsFromArray:[self untappedViewWithArray:[self.textFields allObjects]]];
    [views addObjectsFromArray:[self untappedViewWithArray:[self.preloginTapableViews allObjects]]];
    [views addObjectsFromArray:[self untappedViewWithArray:[self.importantTapableViews allObjects]]];
    
    if (views.count > 0) {
        DDLog(@"(views count %ld)", (long)views.count);
        [self tapRandomViewWithViews:views];
        return;
    }
    
    [views addObjectsFromArray:[self untappedViewWithArray:[self.tapableViews allObjects]]];
    
    if (views.count > 0) {
        DDLog(@"(views count %ld)", (long)views.count);
        [self tapRandomViewWithViews:views];
        return;
    }
    
    NSArray *corners = @[[NSValue valueWithCGPoint:CGPointMake(30, 30)], [NSValue valueWithCGPoint:CGPointMake([UIScreen mainScreen].bounds.size.width - 30, 30)], [NSValue valueWithCGPoint:CGPointMake([UIScreen mainScreen].bounds.size.width * 0.25f, [UIScreen mainScreen].bounds.size.height * 0.8f)], [NSValue valueWithCGPoint:CGPointMake([UIScreen mainScreen].bounds.size.width * 0.75f, [UIScreen mainScreen].bounds.size.height * 0.8f)],];
    
    NSUInteger idx = arc4random_uniform((int32_t)(corners.count));
    DDLog(@"(corners count %ld)", (long)corners.count);
    
    [self.operations addObject:[MTSenseLog pointLogWithSenseType:self.type point:[corners[idx] CGPointValue]]];
    
    [MTAutomationBridge tapPoint:[corners[idx] CGPointValue]];
}

#pragma mark - Monkey Tap

- (void)doMonkeyTap {
    DDLog(@"=============doMonkeyTap...");
    NSUInteger x = arc4random_uniform((int32_t)([UIScreen mainScreen].bounds.size.width));
    NSUInteger y = arc4random_uniform((int32_t)([UIScreen mainScreen].bounds.size.width));
    
    x = 30;
    y = 30;
    
    [self.operations addObject:[MTSenseLog pointLogWithSenseType:self.type point:CGPointMake(x, y)]];
    
    [MTAutomationBridge tapPoint:CGPointMake(x, y)];
}

#pragma mark - Taping
- (void)tapRandomViewWithViews:(NSArray *)views {
    if (views.count == 0) {
        return;
    }
    
    NSUInteger idx = arc4random_uniform((int32_t)(views.count));
    UIView *view = [views objectAtIndex:idx];
    
    [self.operations addObject:[MTSenseLog pointLogWithSenseType:self.type point:view.mainWindowPoint]];
    
    [MTAutomationBridge tapView:view];
}


@end
