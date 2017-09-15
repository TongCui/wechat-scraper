
#import "Global.h"
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "MTAutomationBridge.h"
#import "MTGridWindow.h"
#import "WFTaskManager.h"
#import "UIViewController+Tools.h"

@interface CContact

@property(copy, nonatomic) NSString *m_nsNickName;
@property(copy, nonatomic) NSString *m_nsSignature;

@end


@interface ContactInfoViewController

@property(strong, nonatomic) CContact *m_contact;
- (NSDictionary *)accountInfo;

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
  [[WFTaskManager sharedInstance] setup];
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

%new
- (NSDictionary *)accountInfo {
  return @{
    @"nick_name":self.m_contact.m_nsNickName,
    @"signature":self.m_contact.m_nsSignature,
  };
}

%end

%hook UIViewController
- (void)viewDidAppear:(BOOL)animated {
  DDLog(@"viewDidAppear %@", [[self class] description]); 
  //  Post Notification
  [[NSNotificationCenter defaultCenter] postNotificationName:kWF_ViewController_DidAppear_Notification object:self userInfo:nil];
  %orig;
}

%end

%hook MMWebViewController

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
    DDLog(@"%@", [result class]);
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.html",
                          documentsDirectory, @"ok"];

    DDLog(@"Write html to %@", fileName);
    DDLog(@"======");
    DDLog(@"%@", result);
    //save content to the documents directory
    BOOL res = [result writeToFile:fileName atomically:YES encoding:NSStringEncodingConversionAllowLossy error:nil];
    DDLog(@"result is %@", @(res));
  }];
}

- (void)viewDidAppear:(BOOL)animated {
  DDLog(@"MMWebViewController viewDidAppear"); 
  %orig;
  UIView *view = [(UIViewController *)self view];
  [view bringSubviewToFront:[view viewWithTag:777]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  DDLog(@"!!!!shouldStartLoadWithRequest!!!!");
  DDLog(@"headers : %@", request.allHTTPHeaderFields);
  DDLog(@"url : %@", request.URL.absoluteString);
  DDLog(@"!!!!END!!!!");
  return %orig;
}
// NSString *jsCode = @"document.documentElement.outerHTML.toString()";
// NSString *jsCode = @"document.getElementById('WXAPPMSG1000001182').click();";
// NSString *jsCode = @"location.href = document.querySelector('#WXAPPMSG1000001174').getAttribute('hrefs')"; 
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