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

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *clickButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //  For test use
    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    testButton.frame = CGRectMake(100, 200, 100, 44);
    [testButton setTitle:@"Test" forState:UIControlStateNormal];
    [testButton addTarget:self action:@selector(testButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
    //  End
}


- (void)testButtonPressed:(id)sender {
    //  TODO: delete it
    CGRect frame = self.clickButton.frame;
    CGPoint point = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    [MTAutomationBridge tapPoint:point];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)click:(UIButton *)sender {
    DDLog(@"Test Button Click Here");
}


@end
