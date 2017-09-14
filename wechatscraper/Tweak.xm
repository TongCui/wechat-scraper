
#import "Global.h"
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "MTAutomationBridge.h"
#import "MTGridWindow.h"

@interface MMWebViewController

@property (strong) WKWebView *webView;

@end

%group WeChatScraper

%hook MicroMessengerAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  DDLog(@"Wechat didFinishLaunchingWithOptions");
  [[MTGridWindow sharedInstance] makeKeyAndVisible];
  [MTGridWindow sharedInstance].userInteractionEnabled = NO;
  DDLog(@"Set up Grid window");
  return %orig;
}

%new
- (void)testTap:(CGFloat)y {

  CGPoint point = CGPointMake(50, y);
  [MTAutomationBridge tapPoint:point];
}

%end

%hook UIViewController
- (void)viewDidAppear:(BOOL)animated {
  DDLog(@"viewDidAppear %@", [[self class] description]); 
  UIView *view = [(UIViewController *)self view];
  [view bringSubviewToFront:[view viewWithTag:666]];
  %orig;
}

- (void)viewDidLoad {
  DDLog(@"!!!!!!MMWebViewController!!!!!!!!");

  %orig;
  //  For test use
    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    testButton.frame = CGRectMake(100, 200, 100, 44);
    testButton.tag = 666;
    [testButton setTitle:@"Test" forState:UIControlStateNormal];
    [testButton addTarget:self action:@selector(testokButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [[(UIViewController *)self view] addSubview:testButton];
    //  End
}

%new
- (void)testokButtonPressed:(id)sender {
  DDLog(@"!!!!!!!!TODO!!!!!!!!!");
  
  CGPoint point = CGPointMake(50, 100);
  [MTAutomationBridge tapPoint:point];
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