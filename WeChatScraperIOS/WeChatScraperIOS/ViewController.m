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
    

//    id result = @"123123123";
//    DDLog(@"%@", [result class]);
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains
//    (NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    
//    //make a file name to write the data to using the documents directory:
//    NSString *fileName = [NSString stringWithFormat:@"%@/%@.html",
//                          documentsDirectory, [[NSDate date] description]];
//    
//    DDLog(@"Write html to %@", fileName);
//    DDLog(@"======");
//    DDLog(@"%@", result);
//    //save content to the documents directory
//    BOOL res = [result writeToFile:fileName atomically:YES encoding:NSStringEncodingConversionAllowLossy error:nil];
//    DDLog(@"result is %@", @(res));
    
    [WFTaskManager sharedInstance].lastViewController = self;
    [WFTaskManager sharedInstance].lastVCClassName = @"ViewController";
    [[WFTaskManager sharedInstance] setupTest];
    [[WFTaskManager sharedInstance] start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)click:(UIButton *)sender {
    DDLog(@"Test Button Click Here");
}


@end
