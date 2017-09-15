//
//  ViewController.m
//  WeChatScraperIOS
//
//  Created by tcui on 13/9/2017.
//  Copyright © 2017 LuckyTR. All rights reserved.
//

#import "ViewController.h"
#import "MTAutomationBridge.h"
#import "Global.h"
#import "WFTaskManager.h"
#import "WFWechatSessionLog.h"
#import "WFWechatAccountLog.h"
#import "DDJSONKit.h"
#import "AFNetworking.h"
#import "NSString+Tools.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *clickButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //  For test use
    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    testButton.frame = CGRectMake(200, 100, 60, 44);
    [testButton setTitle:@"Test" forState:UIControlStateNormal];
    [testButton addTarget:self action:@selector(testButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
    //  End
    

}



- (NSString *)title {
    return nil;
}

- (void)testButtonPressed:(id)sender {
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"log" ofType:@"json"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
//    NSDictionary *params = [DDJSONKit objectFromJSONString:content];
//    NSDictionary *parameters = @{@"test":@(1), @"html":@"sometext"};
    
    NSString *urlString = @"http://13.229.121.69:8000/foo";
    
    
    NSData *postData = [content dataUsingEncoding:NSUTF8StringEncoding];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:nil error:nil];
    request.timeoutInterval= 100;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"text/html" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:postData];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"responseObject: %@", responseObject);
        } else {
            NSLog(@"error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];
    
    
    
//    [WFTaskManager sharedInstance].lastViewController = self;
//    [WFTaskManager sharedInstance].lastVCClassName = @"ViewController";
//    [[WFTaskManager sharedInstance] setupTest];
//    [[WFTaskManager sharedInstance] start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)click:(UIButton *)sender {
    DDLog(@"Test Button Click Here");
}


@end
