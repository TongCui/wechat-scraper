
#import "Global.h"
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "MTAutomationBridge.h"
#import "MTGridWindow.h"
#import "WFTaskManager.h"

@interface CContact

@property(copy, nonatomic) NSString *m_nsNickName;
@property(copy, nonatomic) NSString *m_nsSignature;

@end

@interface ContactInfoViewController

@property(strong, nonatomic) CContact *m_contact;
@property(strong, nonatomic) UIView *view;
- (NSDictionary *)accountInfo;
- (UIView *)historyCell;

@end

@interface MMWebViewController

@property (strong) WKWebView *webView;

@end

%group WeChatScraper

%hook MicroMessengerAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  DDLog(@"Wechat didFinishLaunchingWithOptions");
  [[MTGridWindow sharedInstance] makeKeyAndVisible];
  [MTGridWindow sharedInstance].userInteractionEnabled = NO;
  // [[WFTaskManager sharedInstance] setup];
  DDLog(@"Set up Grid window");
  return %orig;
}

%new
- (void)testTap:(NSString *)xy {
  NSArray *values = [xy componentsSeparatedByString:@","];
  CGPoint point = CGPointMake([values.firstObject floatValue], [values.lastObject floatValue]);
  
  [MTAutomationBridge tapPoint:point];
}

%new
- (void)testType:(NSString *)input {
  [MTAutomationBridge typeIntoKeyboard:input];
}

%end

/* profile page */
%hook ContactInfoViewController

- (void)viewDidAppear:(BOOL)animated {
  DDLog(@"accountTitle %@", [self accountInfo]); 
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [MTAutomationBridge tapView:[self historyCell]];
  });
  %orig;
}

%new
- (NSDictionary *)accountInfo {
  return @{
    @"nick_name":self.m_contact.m_nsNickName,
    @"signature":self.m_contact.m_nsSignature,
  };
}

%new
- (UIView *)historyCell {
  UITableView *tableView = [[self view] subviews][0];
  NSArray *cells = [tableView visibleCells];
  return cells.lastObject;
}

%end

%hook UIViewController
- (void)viewDidAppear:(BOOL)animated {
  DDLog(@"viewDidAppear %@", [[self class] description]); 

  //  Post Notification
  [[NSNotificationCenter defaultCenter] postNotificationName:kWF_ViewController_DidAppear_Notification object:nil userInfo:@{@"class": [[self class] description]}];
 
  %orig;
}

%end

%hook MMWebViewController

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  DDLog(@"!!!!shouldStartLoadWithRequest!!!!");
  DDLog(@"headers : %@", request.allHTTPHeaderFields);
  DDLog(@"url : %@", request.URL.absoluteString);
  DDLog(@"!!!!END!!!!");
  return %orig;
}

- (void)viewDidAppear:(BOOL)animated {
  DDLog(@"MMWebViewController viewDidAppear"); 
  %orig;
  UIView *view = [(UIViewController *)self view];
  [view bringSubviewToFront:[view viewWithTag:777]];
}

- (void)viewDidLoad {

  %orig;
  //  For test use
    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    testButton.frame = CGRectMake(100, 200, 100, 44);
    testButton.tag = 777;
    [testButton setTitle:@"Test" forState:UIControlStateNormal];
    [testButton addTarget:self action:@selector(testButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [[(UIViewController *)self view] addSubview:testButton];
    //  End
}

%new
- (void)testButtonPressed:(id)sender {
    //  TODO: delete it
  DDLog(@"!!!!!!!!testButtonPressed!!!!!!!!!");
  WKWebView *webView = self.webView;
  DDLog(@"web view is %@", webView);
  NSString *jsCode = @"document.documentElement.outerHTML.toString()";
  // NSString *jsCode = @"document.getElementById('WXAPPMSG1000001182').click();";
  // NSString *jsCode = @"location.href = document.querySelector('#WXAPPMSG1000001174').getAttribute('hrefs')";
  DDLog(@"Running script %@", jsCode);
  [webView evaluateJavaScript:jsCode completionHandler:^(id result, NSError * _Nullable error) {
        DDLog(@"%@", result);
  }];
}

%end

%hook WKWebView

- (WKNavigation *)loadRequest:(NSURLRequest *)request {
  DDLog(@"!!!!loadRequest!!!!");
  DDLog(@"headers : %@", request.allHTTPHeaderFields);
  DDLog(@"url : %@", request.URL.absoluteString);
  DDLog(@"!!!!END!!!!");
  return %orig;
}

- (WKNavigation *)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL {
  DDLog(@"!!!!loadHTMLString!!!!");
  
  DDLog(@"string : %@", string);
  DDLog(@"!!!!END!!!!");
  return %orig;

}

- (WKNavigation *)loadData:(NSData *)data MIMEType:(NSString *)MIMEType characterEncodingName:(NSString *)characterEncodingName baseURL:(NSURL *)baseURL {
  DDLog(@"!!!!loadData %@!!!!", MIMEType);
  return %orig;
}
%end

%end


%ctor{
  if ([kBundleId isEqualToString:@"com.tencent.xin"]) {
    DDLog(@"WeChat Scraper Init...");
    %init(WeChatScraper);
    DDLog(@"WeChat Scraper Init Done...");
  } 
}