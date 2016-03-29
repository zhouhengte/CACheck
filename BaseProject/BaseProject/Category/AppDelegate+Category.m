//
//  AppDelegate+Category.m
//  BaseProject
//
//  Created by mis on 15/12/16.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "AppDelegate+Category.h"
//电池条上网络活动提示
#import <AFNetworkActivityIndicatorManager.h>

@implementation AppDelegate (Category)

-(void)initializeWithApplication:(UIApplication *)application
{
    //注册DDLog
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance]setColorsEnabled:YES];
    //当使用AF发送网络请求时，只要有网络操作，那么在状态栏（电池条）wifi符号旁边显示 菊花提示(网络是否下载监测功能)
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    //能够监测当前网络是wifi，蜂窝网络，没有网
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //网络发生变化时 会触发这里的代码
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                DDLogVerbose(@"当前是wifi环境");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                DDLogVerbose(@"当前无网络");
                break;
            case AFNetworkReachabilityStatusUnknown:
                DDLogVerbose(@"当前网络未知");
            case AFNetworkReachabilityStatusReachableViaWWAN:
                DDLogVerbose(@"当前是蜂窝网络");
                break;
            default:
                break;
        }
    }];
    //开启网络状态监测
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    //网络活动发生变化时，会发送下方key的通知，可用在通知中心中添加检测
//    [[NSNotificationCenter defaultCenter]addObserver:nil selector:nil name:AFNetworkingReachabilityDidChangeNotification object:nil];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
