
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#define kBundleId ([[NSBundle mainBundle] bundleIdentifier])

@interface MMWebViewController

@property (strong) WKWebView *webView;

@end

%group WeChatScraper

%hook UIViewController
- (void)viewDidAppear:(BOOL)animated {
  NSLog(@"!!!!!!!!======== viewDidAppear %@", [[self class] description]); 
  %orig;
}
%end

%hook MMWebViewController

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  NSLog(@"!!!!shouldStartLoadWithRequest!!!!");
  NSLog(@"headers : %@", request.allHTTPHeaderFields);
  NSLog(@"url : %@", request.URL.absoluteString);
  NSLog(@"!!!!END!!!!");
  return %orig;
}

- (void)viewDidAppear:(BOOL)animated {
  NSLog(@"!!!!!!!!======== MMWebViewController viewDidAppear"); 
  %orig;
  UIView *view = [(UIViewController *)self view];
  [view bringSubviewToFront:[view viewWithTag:777]];
}

- (void)viewDidLoad {
  NSLog(@"!!!!!!MMWebViewController!!!!!!!!");

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
  NSLog(@"!!!!!!!!testButtonPressed!!!!!!!!!");
  WKWebView *webView = self.webView;
  NSLog(@"web view is %@", webView);
  NSString *jsCode = @"document.documentElement.outerHTML.toString()";
  // NSString *jsCode = @"document.getElementById('WXAPPMSG1000001182').click();";
  // NSString *jsCode = @"location.href = document.querySelector('#WXAPPMSG1000001174').getAttribute('hrefs')";
  NSLog(@"Running script %@", jsCode);
  [webView evaluateJavaScript:jsCode completionHandler:^(id result, NSError * _Nullable error) {
        NSLog(@"%@", result);
  }];
}

%end

%hook WKWebView

- (WKNavigation *)loadRequest:(NSURLRequest *)request {
  NSLog(@"!!!!loadRequest!!!!");
  NSLog(@"headers : %@", request.allHTTPHeaderFields);
  NSLog(@"url : %@", request.URL.absoluteString);
  NSLog(@"!!!!END!!!!");
  return %orig;
}

- (WKNavigation *)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL {
  NSLog(@"!!!!loadHTMLString!!!!");
  
  NSLog(@"string : %@", string);
  NSLog(@"!!!!END!!!!");
  return %orig;

}

- (WKNavigation *)loadData:(NSData *)data MIMEType:(NSString *)MIMEType characterEncodingName:(NSString *)characterEncodingName baseURL:(NSURL *)baseURL {

  NSLog(@"!!!!loadData %@!!!!", MIMEType);
  return %orig;
}
%end

%end


%ctor{
  if ([kBundleId isEqualToString:@"com.tencent.xin"]) {
    NSLog(@"WeChat Scraper Init...");
    %init(WeChatScraper);
    NSLog(@"WeChat Scraper Init Done...");
  } 
}