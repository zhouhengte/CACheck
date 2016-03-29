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
    
    
    // ios8后，需要添加这个注册，才能得到授权(还未注册远程推送，以后实现)
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];

    } else {

        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge];
    }
    
    
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    NSLog(@"localNotification = %@",localNotification);
    if (localNotification) {
        NSLog(@"noti:%@",localNotification);
        
        // 这里真实需要处理交互的地方
        // 获取通知所带的数据
        NSString *notMess = [localNotification.userInfo objectForKey:@"barcode"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"该产品已过期"
                                                        message:notMess
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        // 更新显示的徽章个数
        NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
        badge--;
        badge = badge >= 0 ? badge : 0;
        [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
        
        // 在不需要再推送时，可以取消推送
        [application cancelLocalNotification:localNotification];

    }
    
    return YES;
}


@end
