//
//  MainViewController.m
//  BaseProject
//
//  Created by 刘子琨 on 16/1/11.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "MainViewController.h"
#import "JSBadgeView.h"

#define kScreenScale (self.view.bounds.size.height/568.0)
#define kScreenWidthScale (self.view.bounds.size.width/320.0)

@interface MainViewController ()
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIView *bottomView;

@property (strong, nonatomic) UIButton *scanRecordButton;
@property (strong, nonatomic) UIButton *messageButton;
@property (strong, nonatomic) UIButton *newsButton;
@property (strong, nonatomic) UIButton *preferenceButton;
@property (strong, nonatomic) UILabel *scanRecordLabel;
@property (strong, nonatomic) UILabel *newsLabel;
@property (strong, nonatomic) UILabel *preferenceLabel;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UIImageView *horiztonImageView;
@property (strong, nonatomic) UIImageView *verticalImageView;
@property (strong, nonatomic) JSBadgeView *messageBadgeView;

@property (nonatomic ,strong)NSUserDefaults *userDefaults;

@end

@implementation MainViewController

-(UIView *)bottomView
{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc]init];
        [self.view addSubview:_bottomView];
        _bottomView.backgroundColor = UIColorFromRGB(0xf5f5eb);
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.height.mas_equalTo(282*kScreenScale);
        }];
    }
    return _bottomView;
}

-(UIImageView *)backgroundImageView
{
    if (_backgroundImageView ==nil) {
        _backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bj"]];
        [self.view addSubview:_backgroundImageView];
        [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view);
            make.top.mas_equalTo(self.view);
            make.right.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view).mas_equalTo((-282)*kScreenScale);
        }];
    }
    return _backgroundImageView;
}
-(UIButton *)scanIconButton
{
    if (_scanIconButton == nil) {
        _scanIconButton = [[UIButton alloc]init];
        [_scanIconButton setImage:[UIImage imageNamed:@"扫一扫"] forState:UIControlStateNormal];
        _scanIconButton.contentMode = UIViewContentModeScaleToFill;
        [_scanIconButton addTarget:self action:@selector(goToScanViewController) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_scanIconButton];
        [_scanIconButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(self.backgroundImageView).mas_equalTo(-10);
            make.size.mas_equalTo(CGSizeMake(106*kScreenWidthScale, 106*kScreenWidthScale));
        }];
    }
    return _scanIconButton;
}
-(UIButton *)scanRecordButton
{
    if (_scanRecordButton == nil) {
        _scanRecordButton = [[UIButton alloc]init];
        [_scanRecordButton setImage:[UIImage imageNamed:@"扫描记录"] forState:UIControlStateNormal];
        [_scanRecordButton addTarget:self action:@selector(goToScanRecordViewController) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_scanRecordButton];
        [_scanRecordButton mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.left.mas_equalTo(self.view).mas_equalTo(44.5*kScreenWidthScale);
            make.right.mas_equalTo(self.view).mas_equalTo(-(kScreenWidth/2)-39*kScreenWidthScale);
            make.top.mas_equalTo(self.backgroundImageView.mas_bottom).mas_equalTo(23*kScreenScale);
            make.size.mas_equalTo(CGSizeMake(76*kScreenScale, 76*kScreenScale));
        }];
    }
    return _scanRecordButton;
}
-(UIButton *)messageButton
{
    if (_messageButton == nil) {
        _messageButton = [[UIButton alloc]init];
        [_messageButton setImage:[UIImage imageNamed:@"消息"] forState:UIControlStateNormal];
        [_messageButton addTarget:self action:@selector(goToMessageViewController) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_messageButton];
        [_messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.scanRecordButton);
            make.bottom.mas_equalTo(-43*kScreenScale);
            make.size.mas_equalTo(self.scanRecordButton);
        }];
        
        self.messageBadgeView = [[JSBadgeView alloc]initWithParentView:_messageButton alignment:JSBadgeViewAlignmentTopRight];
        self.messageBadgeView.badgeBackgroundColor = [UIColor clearColor];
        self.messageBadgeView.badgePositionAdjustment = CGPointMake(-15, 15);
        //self.messageBadgeView.badgeStrokeWidth = 2;
        
    }
    return _messageButton;
}
-(UIButton *)newsButton
{
    if (_newsButton == nil) {
        _newsButton = [[UIButton alloc]init];
        [_newsButton setImage:[UIImage imageNamed:@"新闻知识"] forState:UIControlStateNormal];
        [_newsButton addTarget:self action:@selector(goToNewsViewController) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_newsButton];
        [_newsButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(self.scanRecordButton);
            //make.right.mas_equalTo(self.view).mas_equalTo(-44.5*kScreenWidthScale);
            make.left.mas_equalTo(self.view).mas_equalTo(kScreenWidth/2+39*kScreenWidthScale);
            make.size.mas_equalTo(self.scanRecordButton);
        }];
    }
    return _newsButton;
}
-(UIButton *)preferenceButton
{
    if (_preferenceButton == nil) {
        _preferenceButton = [[UIButton alloc]init];
        [_preferenceButton setImage:[UIImage imageNamed:@"设置"] forState:UIControlStateNormal];
        [_preferenceButton addTarget:self action:@selector(goToPreferenceViewController) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_preferenceButton];
        [_preferenceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.newsButton);
            make.centerY.mas_equalTo(self.messageButton);
            make.size.mas_equalTo(self.scanRecordButton);
        }];
    }
    return _preferenceButton;
}
-(UILabel *)scanRecordLabel
{
    if (_scanRecordLabel == nil) {
        _scanRecordLabel = [[UILabel alloc]init];
        _scanRecordLabel.text = @"扫描记录";
        [_scanRecordLabel setFont:[UIFont systemFontOfSize:12]];
        _scanRecordLabel.textColor = UIColorFromRGB(0x363636);
        [self.view addSubview:_scanRecordLabel];
        [_scanRecordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.scanRecordButton);
            make.top.mas_equalTo(self.scanRecordButton.mas_bottom).mas_equalTo(9*kScreenScale);
        }];
    }
    return _scanRecordLabel;
}
-(UILabel *)messageLabel
{
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc]init];
        _messageLabel.text = @"消息";
        [_messageLabel setFont:[UIFont systemFontOfSize:12]];
        _messageLabel.textColor = UIColorFromRGB(0x363636);
        [self.view addSubview:_messageLabel];
        [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.messageButton);
            make.bottom.mas_equalTo(-21*kScreenScale);
        }];
    }
    return _messageLabel;
}
-(UILabel *)newsLabel
{
    if (_newsLabel == nil) {
        _newsLabel = [[UILabel alloc]init];
        _newsLabel.text = @"新闻知识";
        [_newsLabel setFont:[UIFont systemFontOfSize:12]];
        _newsLabel.textColor = UIColorFromRGB(0x363636);
        [self.view addSubview:_newsLabel];
        [_newsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.newsButton);
            make.centerY.mas_equalTo(self.scanRecordLabel);
        }];
    }
    return _newsLabel;
}
-(UILabel *)preferenceLabel
{
    if (_preferenceLabel == nil) {
        _preferenceLabel = [[UILabel alloc]init];
        _preferenceLabel.text = @"设置";
        [_preferenceLabel setFont:[UIFont systemFontOfSize:12]];
        _preferenceLabel.textColor = UIColorFromRGB(0x363636);
        [self.view addSubview:_preferenceLabel];
        [_preferenceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.preferenceButton);
            make.centerY.mas_equalTo(self.messageLabel);
        }];
    }
    return _preferenceLabel;
}
-(UIImageView *)horiztonImageView
{
    if (_horiztonImageView == nil) {
        _horiztonImageView = [[UIImageView alloc]init];
        _horiztonImageView.backgroundColor = UIColorFromRGB(0xe8e6db);
        [self.view addSubview:_horiztonImageView];
        [_horiztonImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.scanRecordButton).mas_equalTo(43*kScreenScale);
            make.size.mas_equalTo(CGSizeMake(234*kScreenWidthScale, 1));
            make.centerX.mas_equalTo(self.view);
        }];
    }
    return _horiztonImageView;
}
-(UIImageView *)verticalImageView
{
    if (_verticalImageView == nil) {
        _verticalImageView = [[UIImageView alloc]init];
        _verticalImageView.backgroundColor = UIColorFromRGB(0xe8e6db);
        [self.view addSubview:_verticalImageView];
        [_verticalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view);
            make.centerY.mas_equalTo(self.horiztonImageView);
            make.size.mas_equalTo(CGSizeMake(1, 196*kScreenScale));
        }];
    }
    return _verticalImageView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.view.backgroundColor = UIColorFromRGB(0xf5f5eb);
    //[self bottomView];
    [self backgroundImageView];
    [self scanIconButton];
    [self scanRecordButton];
    [self messageButton];
    [self newsButton];
    [self preferenceButton];
    [self scanRecordLabel];
    [self messageLabel];
    [self newsLabel];
    [self preferenceLabel];
    [self horiztonImageView];
    [self verticalImageView];
    
    NSLog(@"%f,%f",kScreenHeight,kScreenWidth);
    //友盟获取测试用设备识别信息的代码
    //    Class cls = NSClassFromString(@"UMANUtil");
    //    SEL deviceIDSelector = @selector(openUDIDString);
    //    NSString *deviceID = nil;
    //    if(cls && [cls respondsToSelector:deviceIDSelector]){
    //        deviceID = [cls performSelector:deviceIDSelector];
    //    }
    //    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
    //                                                       options:NSJSONWritingPrettyPrinted
    //                                                         error:nil];
    //
    //    NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"主页面"];//("PageOne"为页面名称，可自定义)
    
    [self.navigationController setNavigationBarHidden:YES];
    
    
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if (badge > 0) {
        self.messageBadgeView.badgeText = @" ";
        UIImage *redPoint = [UIImage imageNamed:@"椭圆 2"];
        UIImageView *redPointImageView = [[UIImageView alloc]initWithImage:redPoint];
        [self.messageBadgeView addSubview:redPointImageView];
        redPointImageView.frame = CGRectMake(11, -7, 12, 12);
        
    }else{
        self.messageBadgeView.badgeText = @"";
        self.messageBadgeView.hidden = YES;
    }
    
    //    self.userDefaults = [NSUserDefaults standardUserDefaults];
    //    NSString *isClick = [self.userDefaults objectForKey:@"messageisclick"];
    //    if ([isClick isEqualToString:@"yes"]) {
    //        self.messageBadgeView.badgeText = @"";
    //    }else{
    //        self.messageBadgeView.badgeText = @" ";
    //    }
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.navigationController.viewControllers.count > 1) {
        self.userDefaults = [NSUserDefaults standardUserDefaults];
        if ([self.from isEqualToString:@"注册"]) {
            if ([[self.userDefaults objectForKey:@"regist"] isEqualToString:@"注册成功"]) {
                MBProgressHUD *Hud = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:Hud];
                Hud.labelText = @"注册成功";
                Hud.labelFont = [UIFont systemFontOfSize:14];
                Hud.mode = MBProgressHUDModeText;
                //            hud.yOffset = 250;
                [Hud showAnimated:YES whileExecutingBlock:^{
                    sleep(1.5);
                    
                } completionBlock:^{
                    [Hud removeFromSuperview];
                    self.from = nil;
                    
                }];
                
            }
            
        }
        
        if ([self.from isEqualToString:@"登录成功"]) {
            if ([[self.userDefaults objectForKey:@"login"] isEqualToString: @"登录成功"]) {
                MBProgressHUD *Hud = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:Hud];
                Hud.labelText = @"登录成功";
                Hud.labelFont = [UIFont systemFontOfSize:14];
                Hud.mode = MBProgressHUDModeText;
                //            hud.yOffset = 250;
                [Hud showAnimated:YES whileExecutingBlock:^{
                    sleep(1.5);
                    
                } completionBlock:^{
                    [Hud removeFromSuperview];
                    self.from = nil;
                }];
            }
        }
        if ([self.from isEqualToString:@"退出登录"]) {
            if ([[self.userDefaults objectForKey:@"logout"] isEqualToString:@"退出登录"])
            {
                MBProgressHUD *Hud = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:Hud];
                Hud.labelText = @"已退出登录";
                Hud.labelFont = [UIFont systemFontOfSize:14];
                Hud.mode = MBProgressHUDModeText;
                //            hud.yOffset = 250;
                [Hud showAnimated:YES whileExecutingBlock:^{
                    sleep(1.5);
                    
                } completionBlock:^{
                    [Hud removeFromSuperview];
                    self.from = nil;
                }];
            }
        }
        
    }
    //从navigationController中删除别的视图控制器，使该页面无法右滑跳转
    [self.navigationController setViewControllers:@[self]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"主页面"];
}

-(void)goToScanRecordViewController
{
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"scanRecordViewController"] animated:YES];
}

-(void)goToScanViewController
{
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"scanViewController"] animated:YES];
}
-(void)goToNewsViewController
{
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"newsViewController"] animated:YES];
}

-(void)goToMessageViewController
{
    self.messageBadgeView.badgeText = @"";
    self.messageBadgeView.hidden = YES;
    //[self.userDefaults setObject:@"yes" forKey:@"messageisclick"];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"messageViewController"] animated:YES];
}
-(void)goToPreferenceViewController
{
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"preferenceViewController"] animated:YES];
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
