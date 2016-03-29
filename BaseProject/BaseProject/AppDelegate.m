//
//  AppDelegate.m
//  BaseProject
//
//  Created by tarena on 15/12/15.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Category.h"
#import "MobClick.h"
#import "WelcomeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //设置电池栏颜色，需先在target info中设置View controller-based status bar appearance为NO
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //友盟日活统计key
    [MobClick startWithAppkey:@"564e8ee567e58e64f2003bef" reportPolicy:BATCH channelId:@"Web"];
    //    [MobClick startWithAppkey:@"5660f82e67e58efaa5002135" reportPolicy:BATCH channelId:@"Web"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
#warning 如果是开发状态，切记要写下方代码，否则应用崩溃就不会出现任何提示,会被传到友盟官网
#ifdef DEBUG
    [MobClick setLogEnabled:YES];
#endif
    
    
    //初始化方法
    [self initializeWithApplication:application];
    
    //设置第一次启动进入欢迎页面
    NSUserDefaults * settings1 = [NSUserDefaults standardUserDefaults];
    NSString *key1 = [NSString stringWithFormat:@"is_first"];
    NSString *value = [settings1 objectForKey:key1];
    if ([value isEqualToString:@"false"]) {
        self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
        UINavigationController *naviVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"contentViewController"];
        self.window.rootViewController = naviVC;
        [self.window makeKeyAndVisible];
        //[self enterApp];
        //MainViewController *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
        //[self presentViewController:mainVC animated:YES completion:nil];
    }
    if (!value) {
        NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
        NSString * key = [NSString stringWithFormat:@"is_first"];
        [setting setObject:[NSString stringWithFormat:@"false"] forKey:key];
        [setting synchronize];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
        WelcomeViewController *welVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"welcomeViewController"];
        self.window.rootViewController = welVC;
        [self.window makeKeyAndVisible];
    }
    
    return YES;
}


@end
