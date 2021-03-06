//
//  WFWorkflow.m
//  WeChatScraperIOS
//
//  Created by tcui on 14/9/2017.
//  Copyright © 2017 LuckyTR. All rights reserved.
//

#import "WFWorkflow.h"
#import "WFTaskModel.h"
#import "MTAutomationBridge.h"
#import "UIViewController+Tools.h"
#import "WFTaskManager.h"
#import "WFWechatSessionLog.h"
#import "WFWechatAccountLog.h"
#import "WFWechatArticleLog.h"
#import "UIViewController+Tools.h"
#import "Global.h"

@implementation WFWorkflow

+ (NSArray<NSString *> *)targetAccountIds {
    return @[
//             @"rmrbwx",
//             @"zhanhao668",
//             @"yetingfm",
//             @"lengtoo",
//             @"mimeng7",
//             @"QQ_shijuezhi",
//             @"duhaoshu",
//             @"gaoshi222",
//             @"lengxiaohua2012",
//             @"xinhuashefabu1",
             @"youshucc",
             @"TTXuanPai",
             @"microhugo",
             @"cctvnewscenter",
             @"cxldb001",
             @"Bai-Cao-Yuan",
             @"kawa01",
             @"adjy77",
             @"newsbro",
             @"daaimaomikong",
             @"lengiii",
             @"mgncwx",
             @"fengyuhuangshan",
             @"diandianxingguang888",
             @"fofofo365",
             @"rzt317",
             @"ergoufache",
             @"citybox01",
             @"autohomeweixin",
             @"soyoung111",
             @"qiubai2005",
             @"fgzadmin",
             @"zhengfu",
             @"gxwh001",
             @"shicitiandi",
             @"iiiher",
             @"iyourdaily",
             @"xiaomigongsi0406",
             @"dongbeixiaopin",
             @"loveyou3650",
             @"tiexuejunshi",
             @"shanghaifabu",
             @"xiaoluoegao",
             @"bzryjh",
             @"yer808",
             @"DingXiangYiSheng",
             @"newcaimi",
             @"dashu259",
             @"hahashipin",
             @"mx2772",
             @"Zhongguojiaoyubao",
             @"zhufu569",
             @"lwwuwuwu",
             @"cctvyscj",
             @"gzwcjs",
             @"svipcc365",
             @"baojiandaifu",
             @"Pydp888",
             @"lengxhboss",
             @"yichan6666",
             @"ldgxsp",
             @"dzwz999",
             @"junwu233",
             @"guoguan5000",
             @"gcdyweixin",
             @"taread",
             @"Guokr42",
             @"wzhxlx",
             @"heromoba",
             @"Lifevx365",
             @"ckxxwx",
             @"miercn123",
             @"iyourcar",
             @"yinyue068",
             @"Mogensh",
             @"carpwith",
             @"xd2299",
             @"GSyuedu",
             @"xinwenzaocan",
             @"lingdiancy",
             @"dingxiangwang",
             @"shenyefachi",
             @"hereinuk",
             @"shidian3650",
             @"LifeVista",
             @"yebanfm",
             @"PRSPY007",
             @"FM5887",
             @"duliyumovie",
             @"yuedu58",
             @"cihuai_dushuhui",
             @"kissmemouth",
             @"ttdoushi",
             @"pinpinlife",
             @"hb1180",
             @"gxjhshys",
             @"gougou2016",
             @"gxsh789",
             @"hifm93",
             @"neihanshe",
             ];
}

+ (NSArray<WFTaskModel *> *)testWorkflow {
    NSMutableArray *tasks = [NSMutableArray array];
    WFTaskModel *task = nil;
    
    for (NSUInteger i = 0; i < 10; i++) {
        task = [WFTaskModel taskWithDesc:@"tap" pageClassName:@"ViewController" operation:^(id<WFTaskModelDelegate> caller, WFTaskModel *task) {
            [task.viewController tapPoint:CGPointMake(20 + i * 30, 300)];
            [task notifySuccessDelay:2];
        }];
        [tasks addObject:task];
    }
    
    NSLog(@"!!!!!!!!! tasks count %@", @(tasks.count));
    
    return tasks;
}

+ (NSArray<WFTaskModel *> *)wechatScraperWorkflow {
    
    NSMutableArray *tasks = [NSMutableArray array];
    WFTaskModel *task = nil;
    
    NSTimeInterval nDelay = 1.0f;
    NSTimeInterval sDelay = 0.5f;
    NSTimeInterval lDelay = 1.8f;
    NSTimeInterval webLoadDelay = 2.0f;
    
    
    //  Go To search page
    task = [WFTaskModel taskWithDesc:@"tap '+'" pageClassName:@"NewMainFrameViewController" operation:^(id<WFTaskModelDelegate> caller, WFTaskModel *task) {
        [task.viewController tapPoint:CGPointMake(360, 40)];
        [task notifySuccessDelay:sDelay];
    }];
    [tasks addObject:task];
    
    task = [WFTaskModel taskWithDesc:@"tap 'Add Friends'" pageClassName:@"NewMainFrameViewController" operation:^(id<WFTaskModelDelegate> caller, WFTaskModel *task) {
        [task.viewController tapPoint:CGPointMake(310, 140)];
        [task notifySuccessDelay:nDelay];
    }];
    [tasks addObject:task];
    
    
    task = [WFTaskModel taskWithDesc:@"tap 'public accounts'" pageClassName:@"AddFriendEntryViewController" operation:^(id<WFTaskModelDelegate> caller, WFTaskModel *task) {
        [task.viewController tapCell:-1];
        [task notifySuccessDelay:lDelay];
    }];
    [tasks addObject:task];
    
    [[self targetAccountIds] enumerateObjectsUsingBlock:^(NSString * _Nonnull accountId, NSUInteger idx, BOOL * _Nonnull stop) {
        WFTaskModel *task = nil;
        
        if (idx > 0) {
            //  Tap Search
            task = [WFTaskModel taskWithDesc:@"tap 'Search bar'" pageClassName:@"FindBrandViewController" operation:^(id<WFTaskModelDelegate> caller, WFTaskModel *task) {
                [task.viewController tapPoint:CGPointMake(180, 40)];
                [task notifySuccessDelay:sDelay];
            }];
            [tasks addObject:task];
            
            
            //  Tap Clear Button
            task = [WFTaskModel taskWithDesc:@"tap 'Clear Button'" pageClassName:@"FindBrandViewController" operation:^(id<WFTaskModelDelegate> caller, WFTaskModel *task) {
                [task.viewController tapPoint:CGPointMake(300, 40)];
                [task notifySuccessDelay:sDelay];
            }];
            [tasks addObject:task];
        }
        
        
        //  Search keyword
        task = [WFTaskModel taskWithDesc:[NSString stringWithFormat:@"search 'Account ID (%@)'", accountId] pageClassName:@"FindBrandViewController" operation:^(id<WFTaskModelDelegate> caller, WFTaskModel *task) {
            [task.viewController typeInput:[NSString stringWithFormat:@"%@\n", accountId]];
            [task notifySuccessDelay:nDelay];
        }];
        [tasks addObject:task];
        
        //  Tap first cell, note. it is not a table view
        task = [WFTaskModel taskWithDesc:@"tap 'Target Account'" pageClassName:@"FindBrandViewController" operation:^(id<WFTaskModelDelegate> caller, WFTaskModel *task) {
            [task.viewController tapPoint:CGPointMake(180, 170)];
            [task notifySuccessDelay:nDelay];
        }];
        task.retryCount = 3;
        [tasks addObject:task];
        
        //  Tap History
        task = [WFTaskModel taskWithDesc:@"tap 'history cell'" pageClassName:@"ContactInfoViewController" operation:^(id<WFTaskModelDelegate> caller, WFTaskModel *task) {
            [[WFTaskManager sharedInstance].log appendAccountLog:[WFWechatAccountLog accountWithID:accountId]];
            [[WFTaskManager sharedInstance].log appendAccountInfo:[task.viewController performSelector:@selector(accountInfo)]];
            [task.viewController tapCell:-1];
            [task notifySuccessDelay:nDelay];
        }];
        [tasks addObject:task];
        
        //  Waiting for load
        task = [WFTaskModel taskWithDesc:@"waiting for html did load" pageClassName:@"MMWebViewController" operation:^(id<WFTaskModelDelegate> caller, WFTaskModel *task) {
            [task notifySuccessDelay:2.5f];
        }];
        [tasks addObject:task];
        
        //  Collect list html
        task = [WFTaskModel taskWithDesc:@"Collect HTML string" pageClassName:@"MMWebViewController" operation:^(id<WFTaskModelDelegate> caller, WFTaskModel *task) {
            
            
            WKWebView *webView = (WKWebView *)[task.viewController webView];
            if (nil != webView) {
                NSString *jsCode = @"document.documentElement.outerHTML.toString()";
                DDLog(@"Running script %@", jsCode);
                [webView evaluateJavaScript:jsCode completionHandler:^(id result, NSError * _Nullable error) {
                    
                    NSArray *articleElementIds = [[self class] articleElementIdsFromHTML:result];
                    [[WFTaskManager sharedInstance].log appendAriticleElementIds:articleElementIds];
                    
                    [task notifySuccessDelay:0];
                }];
            } else {
                [task notifyFailed:@"[WF ERROR] no web view in this page"];
            }
            
        }];
        [tasks addObject:task];
        
        
        
        for (NSUInteger articleIdx = 0; articleIdx < 10; articleIdx++) {
            //  Perform js location
            task = [WFTaskModel taskWithDesc:@"JS - Navigate to Article" pageClassName:@"MMWebViewController" operation:^(id<WFTaskModelDelegate> caller, WFTaskModel *task) {
                
                NSArray *articleElementIds = [WFTaskManager sharedInstance].log.accounts.lastObject.articleElementIds;
                
                if (articleIdx < articleElementIds.count) {
                    NSString *articleElementId = articleElementIds[articleIdx];
                    DDLog(@"[WF] Goting to navigate to %@", articleElementId);
                    
                    WKWebView *webView = (WKWebView *)[task.viewController webView];
                    
                    NSString *jsCode = [NSString stringWithFormat:@"location.href = document.querySelector('#%@').getAttribute('hrefs')", articleElementId];
                    DDLog(@"Running script %@", jsCode);
                    [webView evaluateJavaScript:jsCode completionHandler:^(id result, NSError * _Nullable error) {
                        [task notifySuccessDelay:webLoadDelay];
                    }];
                } else {
                    [task notifySuccessDelay:0];
                }
            
            }];
            [tasks addObject:task];
            

            //  Collect html string
            task = [WFTaskModel taskWithDesc:@"Collect HTML string" pageClassName:@"MMWebViewController" operation:^(id<WFTaskModelDelegate> caller, WFTaskModel *task) {

                NSArray *articleElementIds = [WFTaskManager sharedInstance].log.accounts.lastObject.articleElementIds;
                
                if (articleIdx < articleElementIds.count) {
                    WKWebView *webView = (WKWebView *)[task.viewController webView];
                    
                    NSString *jsCode = @"document.documentElement.outerHTML.toString()";
                    DDLog(@"Running script %@", jsCode);
                    [webView evaluateJavaScript:jsCode completionHandler:^(id result, NSError * _Nullable error) {
                        
                        [[WFTaskManager sharedInstance].log appendHTML:result];
                        [task notifySuccessDelay:0];
                    }];
                } else {
                    [task notifySuccessDelay:0];
                }
                
            }];
            [tasks addObject:task];
            
            //  Perform js back
            task = [WFTaskModel taskWithDesc:@"JS - Back" pageClassName:@"MMWebViewController" operation:^(id<WFTaskModelDelegate> caller, WFTaskModel *task) {
                
                NSArray *articleElementIds = [WFTaskManager sharedInstance].log.accounts.lastObject.articleElementIds;
                
                if (articleIdx < articleElementIds.count) {
                    WKWebView *webView = (WKWebView *)[task.viewController webView];
                    
                    NSString *jsCode = @"history.back()";
                    [webView evaluateJavaScript:jsCode completionHandler:^(id result, NSError * _Nullable error) {
                        [task notifySuccessDelay:sDelay];
                    }];
                } else {
                    [task notifySuccessDelay:0];
                }
                
            }];
            [tasks addObject:task];
        }
        
        //  Back
        task = [WFTaskModel taskWithDesc:@"tap 'Back'" pageClassName:@"MMWebViewController" operation:^(id<WFTaskModelDelegate> caller, WFTaskModel *task) {
            
            [task.viewController tapPoint:CGPointMake(35, 40)];
            [task notifySuccessDelay:nDelay];
        }];
        [tasks addObject:task];
        
        //  Back
        task = [WFTaskModel taskWithDesc:@"tap 'Back'" pageClassName:@"ContactInfoViewController" operation:^(id<WFTaskModelDelegate> caller, WFTaskModel *task) {
            
            [task.viewController tapPoint:CGPointMake(35, 40)];
            [task notifySuccessDelay:nDelay];
        }];
        [tasks addObject:task];
    }];
    
    return [tasks copy];
}


+ (NSArray<NSString *> *)articleElementIdsFromHTML:(NSString *)html {
    NSString *searchedString = html;
    NSRange searchedRange = NSMakeRange(0, [searchedString length]);
    // <div id="WXAPPMSG\d+" class="weui_media_box appmsg js_appmsg" hrefs="[^"]+">
    NSString *pattern = @"<div id=\"WXAPPMSG\\d+\" class=\"weui_media_box appmsg js_appmsg\" hrefs=\"[^\"]+\">";
    NSError *error = nil;
    
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern: pattern options:0 error:&error];
    NSArray* matches = [regex matchesInString:searchedString options:0 range: searchedRange];
    NSMutableArray *res = [NSMutableArray array];
    for (NSTextCheckingResult* match in matches) {
        //  <div id="WXAPPMSG1000002986" class="weui_media_box appmsg js_appmsg" hrefs="http://mp.weixin.qq.com/s?__biz=MjM5MjAxNDM4MA==&amp;mid=2666167597&amp;idx=1&amp;sn=247d628e716be986df9805ad76347b05&amp;chksm=bdb2146e8ac59d78e25a55e9cdf7b645761a116c967f3108fa196183a8e3280549c6ed6d300d&amp;scene=38#wechat_redirect">
        NSString *matchText = [searchedString substringWithRange:[match range]];
        NSString *articleId = [matchText substringWithRange:NSMakeRange(9, 18)];
        [res addObject:articleId];
        DDLog(@"match: %@", articleId);
    }
    
    return [res copy];
}

@end
