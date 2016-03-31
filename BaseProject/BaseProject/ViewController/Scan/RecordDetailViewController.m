//
//  RecordDetailViewController.m
//  BaseProject
//
//  Created by 刘子琨 on 16/1/13.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "RecordDetailViewController.h"
#import "BaseModel.h"
#import "ProductInfoModel.h"
#import "SDCycleScrollView.h"
#import "Reachability.h"
#import "PictureViewController.h"
#import "RecordDetailTableViewCell.h"
#import "EvaluateTableViewCell.h"
#import "MainViewController.h"
#import "WebViewController.h"
#import "DueDateView.h"


@interface RecordDetailViewController ()<UITableViewDataSource, UITableViewDelegate,SDCycleScrollViewDelegate>

@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , strong)UIPageControl *pageControl;
@property (nonatomic , copy)NSString *str;//码值
@property (nonatomic , strong)NSDictionary *paramDic;
@property (nonatomic , copy)NSString *requestUrl;
@property (nonatomic , strong)NSMutableArray *textArray;//子标题
@property (nonatomic , copy)NSString *picUrl;
@property (nonatomic , strong)NSMutableArray *picArray;
@property (nonatomic , copy)NSString *saleFlag;
@property (nonatomic , copy)NSString *CoatCode;
@property (nonatomic , copy)NSString *url;
@property (nonatomic , strong)NSMutableArray *sectionArray;//最后一个section个数
@property (nonatomic , strong)UILabel *painLabel;
@property (nonatomic , strong)UITextField *secondField;
@property (nonatomic , strong)NSString *key;

//定义一个可变数组， 用来放baseModel中的数据
@property (nonatomic , strong)NSMutableArray *baseArray;//名称，检验状态，大图，扫码次数
@property (nonatomic , strong)NSMutableArray *productInfoArray;//2个数组，基本信息和报检信息
@property (nonatomic , strong)NSMutableArray *localArray;//存放本地所有数据

@property (nonatomic , strong)NSDictionary *wantDic;//过滤后想要的那个商品的数据

@property (nonatomic , strong) UIView *naviView;

@property (nonatomic , strong)UIButton *btn;
@property (nonatomic , strong)UIImageView *imageView;
@property (nonatomic , strong)UIButton *button;

@property (nonatomic , strong)UIButton *duedataButton;
@property (nonatomic , strong)UIImageView *duedataImageView;

@end

@implementation RecordDetailViewController
-(NSMutableArray *)baseArray
{
    if (!_baseArray) {
        self.baseArray = [NSMutableArray array];
    }
    return _baseArray;
}
-(NSMutableArray *)productInfoArray
{
    if (!_productInfoArray) {
        self.productInfoArray = [NSMutableArray array];
    }
    return _productInfoArray;
}

-(NSMutableArray *)picArray
{
    if (!_picArray) {
        self.picArray = [NSMutableArray array];
    }
    return _picArray;
}
-(NSMutableArray *)sectionArray{
    if (!_sectionArray) {
        self.sectionArray = [NSMutableArray array];
    }
    return _sectionArray;
}
-(NSMutableArray *)localArray
{
    if (!_localArray) {
        self.localArray = [NSMutableArray array];
    }
    return _localArray;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    

//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    // Do any additional setup after loading the view from its nib.


    

    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height ) style:UITableViewStylePlain];
    
    // tableViewCell 分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.alwaysBounceVertical = YES;
    self.tableView.bounces = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:self.tableView];
    
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //表头视图，上方大图
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 287/586.0*kScreenHeight)];
    
    self.tableView.tableHeaderView.backgroundColor = [UIColor whiteColor];
    
    
    if ([self.sugueStr isEqualToString:@"list"]) {
        [self getLocalData];
    }else{
        
        [self getDataUrl];
    }
    

    
    
    
    self.countKey = @"1";
    __someBool = true;
    __anotherBool = true;
    
    [self.tableView registerClass:[EvaluateTableViewCell class] forCellReuseIdentifier:@"evalueateID"];

    
    //重新设置导航栏，隐藏原生导航栏，手动绘制新的导航栏，使右滑手势跳转时能让导航栏跟着变化
    [self setNavigationBar];
    //设置到期日按钮
    [self setDuedataButton];
}


-(void)setNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
    
    self.naviView = [[UIView alloc]init];
    self.naviView.alpha = 0;
    self.naviView.backgroundColor = [UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1.0];
    [self.view addSubview:self.naviView];
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1.0];
    label.text = @"云检";
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.naviView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    UIImage *image = [UIImage imageNamed:@"返回箭头"];
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    //    self.button.backgroundColor = [UIColor cyanColor];
    [self.button addTarget:self action:@selector(leftBarButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    self.button.frame = CGRectMake(0, 0, 70, 64);
    //    self.button.backgroundColor = [UIColor redColor];
    self.button.userInteractionEnabled = YES;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 27, 29, 29)];
    imageView.image = [UIImage imageNamed:@"返回bg"];
    [self.button addSubview:imageView];
    
    //    [self.button setBackgroundImage:[UIImage imageNamed:@"返回bg"] forState:UIControlStateNormal];
    //UIImage *image = [UIImage imageNamed:@"返回箭头"];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(24, 32, 11, 19)];
    //    self.imageView.backgroundColor = [UIColor grayColor];
    self.imageView.image = image;
    
    [self.view addSubview:self.button];
    [self.view addSubview:self.imageView];

    
    
    //由于改写了leftBarButtonItem,所以需要重新定义右滑返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
}

-(void)setDuedataButton
{
    self.duedataButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.duedataButton];
    [self.duedataButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(27);
        make.right.mas_equalTo(-16);
        make.size.mas_equalTo(CGSizeMake(29, 29));
    }];
    [self.duedataButton addTarget:self action:@selector(duedataClick) forControlEvents:UIControlEventTouchUpInside];
    [self.duedataButton setBackgroundImage:[UIImage imageNamed:@"返回bg"] forState:UIControlStateNormal];
    
    self.duedataImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"闹钟2"]];
    [self.view addSubview:self.duedataImageView];
    [self.duedataImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(32);
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(20, 18));
    }];
    
}

//设置到期日期
-(void)duedataClick
{
    //半透明背景
    UIView *grayTranslucentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    grayTranslucentView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    [self.view addSubview:grayTranslucentView];
    
    //设置到期日期界面的容器
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kScreenHeight);
        make.left.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 299/586.0*kScreenHeight));
    }];
    
    [bottomView layoutIfNeeded];
    
    //设置到期日期的界面
    DueDateView *duedateView = [[DueDateView alloc]initWithFrame:bottomView.frame andJudgeStr:nil];
    [bottomView addSubview:duedateView];
    [bottomView layoutIfNeeded];
    //跳出动画
    [UIView animateWithDuration:0.5 animations:^{
        [bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(287/586.0*kScreenHeight);
            make.left.mas_equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, 299/586.0*kScreenHeight));
        }];
        [bottomView setNeedsLayout];
        [bottomView layoutIfNeeded];
    }];
    //设置取消按钮的block
    duedateView.cancelBlock = ^(){
        [grayTranslucentView removeFromSuperview];
        [UIView animateWithDuration:0.5 animations:^{
            [bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(kScreenHeight);
                make.left.mas_equalTo(self.view);
                make.size.mas_equalTo(CGSizeMake(kScreenWidth, 299/586.0*kScreenHeight));
            }];
            [bottomView setNeedsLayout];
            [bottomView layoutIfNeeded];
        }completion:^(BOOL finished) {
            //完成后将容器移除
            [bottomView removeFromSuperview];
        }];
    };
    
    //设置确认按钮的block
    duedateView.confirmBlock = ^(NSDate *date)
    {
        NSLog(@"到期日期：%@",date);
        //已完成设置界面的容器
        UIView *isSettedBottomView = [[UIView alloc]init];
        isSettedBottomView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:isSettedBottomView];
        [isSettedBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kScreenHeight);
            make.left.mas_equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, 311/586.0*kScreenHeight));
        }];
        [isSettedBottomView layoutIfNeeded];
        //设置已完成界面
        DueDateView *isSettedDueDateView = [[DueDateView alloc]initWithFrame:isSettedBottomView.frame isSetted:YES];
        [isSettedBottomView addSubview:isSettedDueDateView];
        [isSettedDueDateView layoutIfNeeded];
        //设置已完成界面的关闭按钮block
        isSettedDueDateView.closeBlock = ^(){
            [grayTranslucentView removeFromSuperview];
            [UIView animateWithDuration:0.5 animations:^{
                [isSettedBottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(kScreenHeight);
                    make.left.mas_equalTo(self.view);
                    make.size.mas_equalTo(CGSizeMake(kScreenWidth, 299/586.0*kScreenHeight));
                }];
                [isSettedBottomView setNeedsLayout];
                [isSettedBottomView layoutIfNeeded];
            }completion:^(BOOL finished) {
                [isSettedBottomView removeFromSuperview];
            }];

        };
        //移除设置界面的容器，跳出已完成界面的容器
        [UIView animateWithDuration:0.5 animations:^{
            [bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(kScreenHeight);
                make.left.mas_equalTo(self.view);
                make.size.mas_equalTo(CGSizeMake(kScreenWidth, 299/586.0*kScreenHeight));
            }];
            [isSettedBottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(275/586.0*kScreenHeight);
                make.left.mas_equalTo(self.view);
                make.size.mas_equalTo(CGSizeMake(kScreenWidth, 299/586.0*kScreenHeight));
            }];
            [bottomView setNeedsLayout];
            [bottomView layoutIfNeeded];
            [isSettedBottomView setNeedsLayout];
            [isSettedBottomView layoutIfNeeded];
        }completion:^(BOOL finished) {
            [bottomView removeFromSuperview];
        }];
        
        //设置本地到期推送
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        // 设置触发通知的时间
        NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:30];//60秒后触发
        //NSDate *fireDate = date;
        NSLog(@"fireDate=%@",fireDate);

        notification.fireDate = fireDate;
        // 时区
        notification.timeZone = [NSTimeZone defaultTimeZone];
        // 设置重复的间隔
        //notification.repeatInterval = kCFCalendarUnitMinute;

        // 通知内容
        notification.alertBody =  @"该产品过期了";
        notification.applicationIconBadgeNumber = 1;
        // 通知被触发时播放的声音
        notification.soundName = UILocalNotificationDefaultSoundName;
        // 通知参数
        NSDictionary *userDict = [NSDictionary dictionaryWithObject:self.judgeStr forKey:@"barcode"];
        notification.userInfo = userDict;
        // 执行通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
    };
    

    

    

    
    
//    UIAlertController *setDuedataAlertController = [UIAlertController alertControllerWithTitle:@"到期日期" message:@"设置到期日期" preferredStyle:UIAlertControllerStyleAlert];
//    //添加文本框
//    [setDuedataAlertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.font = [UIFont systemFontOfSize:13];
//        textField.textColor = [UIColor blackColor];
//    }];
//    
//    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSString *dateStr = setDuedataAlertController.textFields[0].text;
//        NSLog(@"duedata = %@",dateStr);
//        if ([self validateData:dateStr]){
//            NSString *duedateStr = [dateStr stringByAppendingString:@" 16:10:00"];
//            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
//            [dateFormatter setDateFormat:@"yyyyMMdd hh:mm:ss"];
//            NSDate *date=[dateFormatter dateFromString:duedateStr];
//            
//            //判断日期是否早于当前时间
//            NSDate *now = [NSDate date];
//            if ([now isEqualToDate:[now laterDate:date]]){
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误"
//                                                                message:@"到期日期早于当前日期"
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"OK"
//                                                      otherButtonTitles:nil];
//                [alert show];
//
//            }
//            
//            UILocalNotification *notification = [[UILocalNotification alloc] init];
//            // 设置触发通知的时间
//            NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:60];//60秒后触发
//            //NSDate *fireDate = date;
//            NSLog(@"fireDate=%@",fireDate);
//            
//            notification.fireDate = fireDate;
//            // 时区
//            notification.timeZone = [NSTimeZone defaultTimeZone];
//            // 设置重复的间隔
//            //notification.repeatInterval = kCFCalendarUnitMinute;
//            
//            // 通知内容
//            notification.alertBody =  @"该产品过期了";
//            notification.applicationIconBadgeNumber = 1;
//            // 通知被触发时播放的声音
//            notification.soundName = UILocalNotificationDefaultSoundName;
//            // 通知参数
//            NSDictionary *userDict = [NSDictionary dictionaryWithObject:self.judgeStr forKey:@"barcode"];
//            notification.userInfo = userDict;
//            // 执行通知
//            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//        }else {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误"
//                                                            message:@"日期格式错误"
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//            [alert show];
//
//        }
//        
//
//
//    }];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    [setDuedataAlertController addAction:confirmAction];
//    [setDuedataAlertController addAction:cancelAction];
//    
//    [self presentViewController:setDuedataAlertController animated:YES completion:nil];
    
}

-(void)sendLocalNotification
{
    
}

//日期正则表达式判断
-(BOOL)validateData:(NSString *)dataStr
{
    NSString *dataRegex = @"^(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))0229)";//yyyyMMdd
//    NSString *dataRegex = @"^(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)";//yyyy-MM-dd
    //NSString *dataRegex = @"([\\d]{4}(((0[13578]|1[02])((0[1-9])|([12][0-9])|(3[01])))|(((0[469])|11)((0[1-9])|([12][0-9])|30))|(02((0[1-9])|(1[0-9])|(2[0-8])))))|((((([02468][048])|([13579][26]))00)|([0-9]{2}(([02468][048])|([13579][26]))))(((0[13578]|1[02])((0[1-9])|([12][0-9])|(3[01])))|(((0[469])|11)((0[1-9])|([12][0-9])|30))|(02((0[1-9])|(1[0-9])|(2[0-9])))))";//yyyyMMdd
    NSPredicate *dataTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", dataRegex];
    return [dataTest evaluateWithObject:dataStr];
}



-(void)leftBarButtonItem:(UIBarButtonItem *)sender
{

    //    [self.navigationController popViewControllerAnimated:YES];
//    if ([self.sugueStr isEqualToString:@"list"]) {
//        //        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
//        [self.navigationController popViewControllerAnimated:YES];
//    }else{
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"扫描记录详情"];//("PageOne"为页面名称，可自定义)
    
//    
//    //[self.view bringSubviewToFront:self.button];
//    
//    self.navigationItem.title = @"云检";
//    //    //自定义导航栏
//    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.btn.frame = CGRectMake(15, 8, 29, 29);
//    self.btn.userInteractionEnabled = YES;
//    //
//    //    [self.btn setBackgroundImage:[UIImage imageNamed:@"返回bg"] forState:UIControlStateNormal];
//    //    self.btn.backgroundColor = [UIColor cyanColor];

//    //
//    if (kScreenHeight == 736) {//6p
//        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 5, 11, 19)];
//    }else{
//        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 5, 11, 19)];
//    }
//    self.imageView.image = image;
//    [self.btn addSubview:self.imageView];
//    //
//    self.imageView.userInteractionEnabled = YES;
//    self.btn.userInteractionEnabled = YES;
//    //
//    [self.btn addTarget: self action: @selector(leftBarButtonItem:) forControlEvents: UIControlEventTouchUpInside];
//    //
//    UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:self.btn];
//    self.navigationItem.leftBarButtonItem = back;
//    
//    //由于改写了leftBarButtonItem,所以需要重新定义右滑返回手势
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
//    //[self.navigationController.interactivePopGestureRecognizer addTarget:self action:@selector(leftBarButtonItem:)];
//    
//    
//    
//    // tableViewCell 分割线
//    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    
//    //    self.navigationController.navigationBar.translucent = YES;
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1.0];
    //    self.navigationController.navigationBar.alpha = 0;
    
    //[super viewDidAppear:animated];
    
    
//    NSLog(@"%@",self.sugueStr);
//    NSLog(@"%@",self.onlyStr);
//    NSLog(@"%f",self.tableView.tableHeaderView.frame.origin.y);
//    self.navigationController.navigationBar.alpha = 1.0;
//    if ([self.onlyStr isEqualToString:@"记录列表"]) {
//        
//        self.navigationController.navigationBar.alpha = 0;
//    }
//    if ([self.sugueStr isEqualToString:@"scan"]) {
//        self.navigationController.navigationBar.alpha = 0;
//    }
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *str = [userDefaults objectForKey:@"pic"];
//    NSString *webStr = [userDefaults objectForKey:@"web"];
//    NSLog(@"%@", str);
//    if ([str isEqualToString:@"图片"]) {
//        self.navigationController.navigationBar.alpha = 0;
//    }
//    if ([webStr isEqualToString:@"web"]) {
//        self.navigationController.navigationBar.alpha = 1;
//        
//    }
    
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"扫描记录详情"];
}


//设置逐渐透明和下拉刷新等
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //      NSLog(@"滚动中");
    //    计算页码
    //    页码 = (contentoffset.x + scrollView一半宽度)/scrollView宽度
    CGFloat scrollviewW =  scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollviewW / 2) /  scrollviewW;
    self.pageControl.currentPage = page;
    
    //动态设置透明度
    if (self.tableView.contentOffset.y == 0) {
        //         self.navigationController.navigationBar.translucent = YES;
        self.naviView.alpha = 0;
        self.button.alpha = 1.0;
        self.duedataButton.alpha = 1.0;
        //         self.btn.alpha = 1.0;
    }else if((self.tableView.contentOffset.y>=0)&&(self.tableView.contentOffset.y <= 40)){
        self.naviView.alpha = 0.2;
        self.button.alpha = 0.8;
        self.duedataButton.alpha = 0.8;
        //         self.btn.alpha = 0.5;
    }else if((self.tableView.contentOffset.y>=40)&&(self.tableView.contentOffset.y <= 80)){
        
        self.naviView.alpha = 0.4;
        self.button.alpha = 0.6;
        self.duedataButton.alpha = 0.6;
        
    }else if((self.tableView.contentOffset.y>=80)&&(self.tableView.contentOffset.y <= 120)){
        
        self.naviView.alpha = 0.6;
        self.button.alpha = 0.4;
        self.duedataButton.alpha = 0.4;
        
        
    }else if ((self.tableView.contentOffset.y>=120)&&(self.tableView.contentOffset.y <= 160)){
        
        self.naviView.alpha = 0.8;
        self.button.alpha = 0.2;
        self.duedataButton.alpha = 0.2;
        
    }else if((self.tableView.contentOffset.y>=160)&&(self.tableView.contentOffset.y <= 200)){
        self.naviView.alpha = 1.0;
        self.button.alpha = 0.1;//保留0.1，不然按钮变透明后无法触发点击事件
        self.duedataButton.alpha = 0.1;
        //         self.imageView.alpha = 0;
        //         self.btn.alpha = 0;
        //         self.button.alpha = 0;
        //         [self.button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        //         self.imageView.alpha = 1.0;
        
    }
    
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height-1) {
        //滑到底部
        self.naviView.alpha = 1.0;
        self.button.alpha = 0.1;
        self.duedataButton.alpha = 0.1;
    }
}


-(void)getLocalData{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:@"test.plist"];
    NSArray * arrayFromfile = [NSArray arrayWithContentsOfFile:plistPath];
    //获取本地所有数据
    self.localArray = [NSMutableArray arrayWithArray: arrayFromfile];
    //NSLog(@"%@",self.judgeStr);
    //NSLog(@"!!!%@",self.localArray);
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in self.localArray) {
        //当key为传入的c码或条码时，存入array
        NSDictionary *dataDic = [dic objectForKey:self.judgeStr];
        if (dataDic == nil) {
            ;
        }else{
            [array addObject:dataDic];
            
        }
    }
    //NSLog(@"%@",[array firstObject]);
    //相同c码或条码的数据，只获取第一个
    self.wantDic = [array firstObject];
    
    self.textArray = [NSMutableArray array];
    NSArray * a = [self.wantDic objectForKey:@"ProductInfo"];
    for (NSDictionary *dict in a) {
        NSString *b = dict[@"text"];
        
        [self.textArray addObject:b];
    }
    //NSLog(@"%@",self.textArray);
#pragma 手动增加商品评价
    [self.textArray addObject:@"商品评价"];//增加商品评价子标题
    
    
    NSArray * baseInfoArray = [self.wantDic objectForKey:@"BaseInfo"];
    //NSLog(@"%@",baseInfoArray);
    for (NSDictionary * innerDic in baseInfoArray) {
        if ([[innerDic objectForKey:@"key"] isEqualToString:@"MultiLabelProof"]) {//获取多图url
            self.picUrl = [innerDic objectForKey:@"url"];
            break;
        }
    }
    if (self.picUrl) {//存在多图url就从网上获取，不存在就放默认图片
        [self getUrlPicLoop];
    }else {
        [self getLocalPicLoop];
    }
    //如果saleFag值为1，已经完成涂层验证，0:未完成涂层验证
    self.saleFlag = self.wantDic[@"SaleFlag"];
    self.CoatCode = self.wantDic[@"CoatCode"];//验证码
#pragma mark - 判断如果self.saleFlag不为空，则有涂层验证
    //设置底部的二次认证框
    [self setBottomButton];
    
    if (self.wantDic == nil) {
        return ;
    }
    //得到baseInfo的信息
    for (NSDictionary *dic in self.wantDic[@"BaseInfo"]) {
        BaseModel *baseModel = [[BaseModel alloc] initWithDict: dic];
        [self.baseArray addObject:baseModel];
    }
    //NSLog(@"%@",self.baseArray);
    //得到productInfo的信息
    NSArray *arr = self.wantDic[@"ProductInfo"];
    //NSLog(@"%@",arr);
    for (NSDictionary *dic in arr) {
        NSMutableArray *smallArr = [NSMutableArray arrayWithCapacity:1];
        NSArray *dataArray = [dic objectForKey:@"data"];
        //NSLog(@"%@",dataArray);
        for (NSDictionary *innerDic in dataArray) {
            ProductInfoModel *productModel = [[ProductInfoModel alloc] initWithDict:innerDic];
            //如果改model中有中文标签的话， 就不加到数组中（如果key ＝ CNProofSample 则删除该cell 并且显示中文标签，并将该url放在中文标签中）
            if ([productModel.key isEqual:@"CNProofSample"]) {
                
                self.url = productModel.value;
                
#pragma mark 将中文标签（商检标签）加到数组中，数组的cout就是最后一个section中cell的个数
                [self.sectionArray insertObject:self.url atIndex:0];
                
            }else{
                [smallArr addObject:productModel];
            }
        }
        //NSLog(@"%@",self.sectionArray);
        [self.productInfoArray addObject:smallArr];
        
    }
    //NSLog(@"%@",self.productInfoArray);
    [self.tableView reloadData];
}


-(void)getDataUrl
{
    //此处加判断， 如果传过来的str带有28位 则赋值给codeStr，否则赋给barStr
    if (self.judgeStr != nil) {
        if (self.judgeStr.length == 28) {
            self.codeStr = self.judgeStr;
        }else{
            self.barCode = self.judgeStr;
        }
    }
    if (self.codeStr != nil) {
        self.str = self.codeStr;
        
        //      NSDictionary *dic = @{@"authCode":self.str,@"username":@"用户名"};
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *roleid = [userDefaults objectForKey:@"roleid"];
        NSString *username = [userDefaults objectForKey:@"username"];
        NSString *userid = [userDefaults objectForKey:@"userid"];
        NSString *strSysVersion = [[UIDevice currentDevice] systemVersion];
        NSString* phoneModel = [[UIDevice currentDevice] model];
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        NSString *winsize= [NSString stringWithFormat:@"%.2f*%.2f",width,height];
        //NSLog(@"%@",winsize);
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        //NSLog(@"%@",roleid);
        //NSLog(@"%@",username);
        [dic setObject:self.str forKey:@"authCode"];
        [dic setObject:strSysVersion forKey:@"versioninfo"];
        [dic setObject:winsize forKey:@"winsize"];
        [dic setObject:phoneModel forKey:@"model"];
        [dic setObject:phoneModel forKey:@"manufacturer"];
        if ([userDefaults objectForKey:@"username"] ) {
            [dic setObject:roleid forKey:@"roleid"];
            [dic setObject:username forKey:@"username"];
            [dic setObject:userid forKey:@"userid"];
        }
        
    //    NSLog(@"%@",dic);
        
        NSString *strDic = [self dictionaryToJson:dic];
        self.paramDic = @{@"json":strDic};
    #pragma mark - c码认证接口
        self.requestUrl = [NSString stringWithFormat:@"%@/%@",kUrl,kAuthCodeUrl];
        //NSLog(@"%@",self.requestUrl);
    }else{
        self.str = self.barCode;
        self.requestUrl = [NSString stringWithFormat:@"%@/%@%@",kUrl,kbarCodeUrl,self.barCode];
        self.paramDic = nil;
       // NSLog(@"%@",self.requestUrl);
    }
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *catoken = [userDefaults objectForKey:@"CA-Token"];
    [manager.requestSerializer setValue:catoken forHTTPHeaderField:@"CA-Token"];
    NSString *stringInt = [NSString stringWithFormat:@"%d",0];
    [manager.requestSerializer setValue:stringInt forHTTPHeaderField:@"Client-Flag"];
    [manager POST:self.requestUrl parameters:self.paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"%@",responseObject);
        
        self.textArray = [NSMutableArray array];
        NSArray * a = [responseObject objectForKey:@"ProductInfo"];
        for (NSDictionary *dict in a) {
            NSString *b = dict[@"text"];
            
            [self.textArray addObject:b];
        }
#pragma mark - 手动添加商品详情
        //[self.textArray addObject:@"商品详情"];
        //        NSString * urlStr = nil;
        NSArray * baseInfoArray = [responseObject objectForKey:@"BaseInfo"];
        for (NSDictionary * innerDic in baseInfoArray) {
            if ([[innerDic objectForKey:@"key"] isEqualToString:@"MultiLabelProof"]) {
                self.picUrl = [innerDic objectForKey:@"url"];
                break;
            }
        }
        if (self.picUrl) {
            [self getUrlPicLoop];
        }else {
            [self getLocalPicLoop];
        }
        
        NSFileManager *fm = [NSFileManager defaultManager];
        //找到documents文件所在的路径
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //获取第一个文件夹的路径
        NSString *filePath = [path objectAtIndex:0];
        //把testPlist文件加入
        NSString *plistPath = [filePath stringByAppendingPathComponent:@"test.plist"];
        NSString *datePlistPath = [filePath stringByAppendingPathComponent:@"date.plist"];
        
        
        
        //开始创建文件
        //        [fm createFileAtPath:plistPath contents:nil attributes:nil];
        BOOL isExit = [fm fileExistsAtPath:filePath];
        //NSLog(@"isExit = %@", isExit ? @"存在" :@"不存在");
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:1];
        NSMutableArray * dateArray = [NSMutableArray arrayWithCapacity:1];
        
        if (!isExit) {
            //            array
        }else {
            //如果存在
            //加判断， 如果在plist文件中已经存在该c码的数据， 则不添加到数组中，否则添加
            
            NSArray * arrayFromfile = [NSArray arrayWithContentsOfFile:plistPath];
            //            [array setArray:arrayFromfile];
            [array addObjectsFromArray:arrayFromfile];
            
            NSArray *dateArrayFromfile = [NSArray arrayWithContentsOfFile:datePlistPath];
            [dateArray addObjectsFromArray:dateArrayFromfile];
        }
        
#warning 创建一个以c码或条码为key，数据为值的键值对字典
        NSDictionary *dic = @{self.str:responseObject};
        /*
         //判断是否在数组中存在
         
         //如果不存在， 则添加到数组中
         */
        //假设str不存在  ， str是通过二维码获取到的
        BOOL isExitStr = NO;
        //        变量数组中的每个字典
        int i = 0;
        for (NSDictionary * innerDic in array) {
            //allkeys数组第一个key  是  str
            NSString * key = [[innerDic allKeys] firstObject];
            //如果 获取到 的 str  和字典中的  key
            if ([key isEqualToString:self.str]) {
                //如果  字典中的key和得到的 str一样，更新数据
                isExitStr = YES;
                [array removeObjectAtIndex:i];
                [dateArray removeObjectAtIndex:i];
                [array insertObject:dic atIndex:0];
                [dateArray insertObject:self.date atIndex:0];
                break;
            }
            i++;
        }

        //如果不存在， 把dic添加到  array中去
        if (!isExitStr) {
            if ([self.onlyStr isEqualToString:@"扫描页"]) {
                //NSLog(@"%@",self.date);
#warning 将之前key为c码或条码的字典插入到数组第一行
                [array insertObject:dic atIndex:0];
                [dateArray insertObject:self.date atIndex:0];
                
            }
        }
        //        }
#pragma mark - 当扫描超过500条的时候， 会将第500条移除
        if (dateArray.count > 500) {
            [dateArray removeLastObject];
            
            [array removeLastObject];
            
            
        }
#warning 将数据存入plist
        [array writeToFile:plistPath atomically:YES];
        [dateArray writeToFile:datePlistPath atomically:YES];
        
        
        
        
        
        //如果saleFag值为1，已经完成涂层验证，0:未完成涂层验证
        self.saleFlag = responseObject[@"SaleFlag"];
        self.CoatCode = responseObject[@"CoatCode"];//验证码
#pragma mark - 判断如果self.saleFlag不为空，则有涂层验证
        [self setBottomButton];
        
        if (responseObject == nil) {
            return ;
        }
        //得到baseInfo的信息
        for (NSDictionary *dic in responseObject[@"BaseInfo"]) {
            BaseModel *baseModel = [[BaseModel alloc] initWithDict: dic];
            [self.baseArray addObject:baseModel];
            //NSLog(@"%@",self.baseArray);
        }
        //得到productInfo的信息
        NSArray *arr = responseObject[@"ProductInfo"];
        for (NSDictionary *dic in arr) {
            NSMutableArray *smallArr = [NSMutableArray arrayWithCapacity:1];
            NSArray *dataArray = [dic objectForKey:@"data"];
            for (NSDictionary *innerDic in dataArray) {
                ProductInfoModel *productModel = [[ProductInfoModel alloc] initWithDict:innerDic];
                //如果改model中有中文标签的话， 就不加到数组中（如果key ＝ CNProofSample 则删除该cell 并且显示中文标签，并将该url放在中文标签中）
                if ([productModel.key isEqual:@"CNProofSample"]) {
                    
                    self.url = productModel.value;
                    
#pragma mark 将中文标签（商检标签）加到数组中，数组的cout就是最后一个section中cell的个数
                    [self.sectionArray insertObject:self.url atIndex:0];
                }else{
                    [smallArr addObject:productModel];
                }
                
            }
            [self.productInfoArray addObject:smallArr];
            //NSLog(@"%@",self.productInfoArray);
            
        }
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

-(void)setBottomButton
{
#pragma mark - 判断如果self.saleFlag不为空，则有涂层验证
    if (self.saleFlag  != nil) {
        self.tableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 48/568.0*kScreenHeight );
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0,self.tableView.frame.size.height,[UIScreen mainScreen].bounds.size.width,48/568.0*kScreenHeight);
        button.backgroundColor = UIColorFromRGB(0xf1f1f1);
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.userInteractionEnabled = YES;
        [self.view addSubview:button];
        
        
        self.painLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,  10, [UIScreen mainScreen].bounds.size.width, 17)];
        if ([self.saleFlag integerValue] == 0) {
            self.painLabel.text = @"涂层验证";
            self.painLabel.textColor = UIColorFromRGB(0x34b5fe);
        }else{
            self.painLabel.text = @"涂层验证(被验证)";
            self.painLabel.textColor = UIColorFromRGB(0xfe3434);
        }
        self.painLabel.font = [UIFont systemFontOfSize:15];
        
        self.painLabel.textAlignment = NSTextAlignmentCenter;
        //            label.userInteractionEnabled = YES;
        [button addSubview:self.painLabel];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0,  32, [UIScreen mainScreen].bounds.size.width, 16)];
        label1.text = @"请刮开标签中的涂层";
        label1.font = [UIFont systemFontOfSize:10];
        label1.textColor = UIColorFromRGB(0x656565);
        
        label1.textAlignment = NSTextAlignmentCenter;
        //            label1.userInteractionEnabled = YES;
        [button addSubview:label1];
        
    }else{
        self.tableView.frame = [UIScreen mainScreen].bounds;
    }
}

#pragma mark - 设置图层认证弹框
-(void)buttonAction:(UIButton *)sender
{
    //NSLog(@"%@",self.codeStr);
    //NSLog(@"点击了button");
    NSString *str = [NSString stringWithFormat:@"此码(%@)已被验证过",self.CoatCode];
    if ([self.saleFlag integerValue] == 1) {
        
        UIAlertView *alert = [[UIAlertView alloc ]initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else if([self.saleFlag integerValue] == 0){
        if (![self isConnectionAvailable]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查网络状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"涂层认证" message:@"请刮开涂层，输入4位二次认证码"delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            self.secondField = [alert textFieldAtIndex:0];
            
            //        self.secondField.keyboardType = UIKeyboardTypeNumberPad;
            
            [alert show];
        }
    }
    
}

#pragma mark - 涂层二次验证
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.secondField resignFirstResponder];
    
    //NSLog(@"点击确定");
    if (buttonIndex == 1) {
        
        
        //NSLog(@"%@",self.secondField.text);
        //将二次认证码发送给后台
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *catoken = [userDefaults valueForKey:@"CA-Token"];
        [manager.requestSerializer setValue:catoken forHTTPHeaderField:@"CA-Token"];
        
        NSString *stringInt = [NSString stringWithFormat:@"%d",0];
        [manager.requestSerializer setValue:stringInt forHTTPHeaderField:@"Client-Flag"];
        NSString *url = [NSString stringWithFormat:@"%@/%@",kUrl,kSecondAuthenticat];
        
        
        //NSLog(@"%@",self.judgeStr);
        if (self.judgeStr == nil) {
            self.judgeStr = self.codeStr;
        }
        //NSLog(@"%@",self.secondField.text);
        
        [manager GET:url parameters:@{@"authCode":self.judgeStr,@"coatCode":self.secondField.text} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //NSLog(@"%@",responseObject);
            if ([responseObject[@"Result"] integerValue] == 1) {
                MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:hud];
                hud.labelText = responseObject[@"FailInfo"];
                hud.labelFont = [UIFont systemFontOfSize:14];
                hud.mode = MBProgressHUDModeText;
                //            hud.yOffset = 250;
                [hud showAnimated:YES whileExecutingBlock:^{
                    sleep(2);
                } completionBlock:^{
                    [hud removeFromSuperview];
                }];
                
            }else{
                NSMutableArray *array = responseObject[@"SaleInfo"];
                NSDictionary *dic = [array objectAtIndex:0];
                MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:hud];
                hud.labelText = dic[@"value"];
                hud.labelFont = [UIFont systemFontOfSize:14];
                hud.mode = MBProgressHUDModeText;
                //            hud.yOffset = 250;
                [hud showAnimated:YES whileExecutingBlock:^{
                    sleep(2);
                } completionBlock:^{
                    [hud removeFromSuperview];
                }];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
        
        
//        [manager GET:url parameters:@{@"authCode":self.judgeStr,@"coatCode":self.secondField.text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"%@",responseObject);
//            if ([responseObject[@"Result"] integerValue] == 1) {
//                
//                
//                
//                MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
//                [self.view addSubview:hud];
//                hud.labelText = responseObject[@"FailInfo"];
//                hud.labelFont = [UIFont systemFontOfSize:14];
//                hud.mode = MBProgressHUDModeText;
//                
//                //            hud.yOffset = 250;
//                
//                
//                [hud showAnimated:YES whileExecutingBlock:^{
//                    sleep(2);
//                } completionBlock:^{
//                    [hud removeFromSuperview];
//                    
//                }];
//                
//                
//                
//            }else{
//                NSMutableArray *array = responseObject[@"SaleInfo"];
//                NSDictionary *dic = [array objectAtIndex:0];
//                
//                MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
//                [self.view addSubview:hud];
//                hud.labelText = dic[@"value"];
//                hud.labelFont = [UIFont systemFontOfSize:14];
//                hud.mode = MBProgressHUDModeText;
//                
//                //            hud.yOffset = 250;
//                
//                
//                [hud showAnimated:YES whileExecutingBlock:^{
//                    sleep(2);
//                } completionBlock:^{
//                    [hud removeFromSuperview];
//                    
//                }];
//                
//                
//            }
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"%@",error);
//        }];
    }
}



#pragma mark - tableViewHeader的点击事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    //    NSLog(@"---点击了第%ld张图片", (long)index);
    PictureViewController *picVC = [[PictureViewController alloc] init];
    [self.navigationController pushViewController:picVC animated:YES];
    //NSLog(@"%@",self.picArray);
    //拿到所点击的数组中的元素
    if (self.picArray.count != 0) {
        
        NSString *str = [self.picArray objectAtIndex:index];
        picVC.url = str;
        picVC.urlArray = self.picArray;
        picVC.index = index;
        //NSLog(@"%@",str);
        
    }else{
        
        UIImage * aImage = [UIImage imageNamed:@"icon1024"];
        NSMutableArray *images = [NSMutableArray arrayWithObjects:aImage, nil];
        
        picVC.urlArray = images;
    }
    //NSLog(@"%@",self.picArray);
    
}


#pragma 判断是否有网络连接
-(BOOL) isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    
    if (!isExistenceNetwork) {
        //        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];//<span style="font-family: Arial, Helvetica, sans-serif;">MBProgressHUD为第三方库，不需要可以省略或使用AlertView</span>
        //        hud.removeFromSuperViewOnHide =YES;
        //        hud.mode = MBProgressHUDModeText;
        //        hud.labelText = NSLocalizedString(INFO_NetNoReachable, nil);
        //        hud.minSize = CGSizeMake(132.f, 108.0f);
        //        [hud hide:YES afterDelay:3];
        return NO;
    }
    
    return isExistenceNetwork;
}




-(void)getUrlPicLoop
{
    
    
    //NSLog(@"%@",self.picUrl);
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    //NSLog(@"%@",self.picArray);
    
    [manager GET:self.picUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"%@",responseObject);
        NSArray *array = responseObject[@"data"];
        //        self.picArray = [NSMutableArray array];
        for (NSDictionary *dic1 in array) {
            NSString *dic2 = [dic1 objectForKey:@"url"];
            //            self.picArray = [NSMutableArray array];
            [self.picArray addObject:dic2];
            
        }
       // NSLog(@"图片数组 %@",self.picArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    
    //网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0,self.tableView.tableHeaderView.frame.size.width, self.tableView.tableHeaderView.frame.size.height) imageURLStringsGroup:nil]; // 模拟网络延时情景
    
    
    
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    
    cycleScrollView2.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    
    cycleScrollView2.delegate = self;
    
    cycleScrollView2.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0];
    
    
    UIImageView *imageViewBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 219/586.0*kScreenHeight, [UIScreen mainScreen].bounds.size.width, 68/586.0*kScreenHeight)];
    UIImage *imageBg = [UIImage imageNamed:@"图片上阴影"];
    imageViewBg.image = imageBg;
    [self.tableView.tableHeaderView addSubview:imageViewBg];
    
    //NSLog(@"%@",self.picArray);
    
    
    [imageViewBg addSubview:_pageControl];
    
    [self.tableView.tableHeaderView addSubview:cycleScrollView2];
    
    cycleScrollView2.infiniteLoop = NO; //关闭循环
    
    
    
    //             --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.picArray.count == 0) {
#pragma mark - 如果请求到的图片数组为空， 则从本地请求，加载背景图片
            [self getLocalPicLoop];
        }else{
            cycleScrollView2.imageURLStringsGroup = self.picArray;
            if (self.picArray.count == 1) {
                //NSLog(@"%@",cycleScrollView2.subviews);
                //如果只有一张图片不展示pageControl
                cycleScrollView2.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
                
            }
            cycleScrollView2.contentMode = UIViewContentModeScaleAspectFit;
            cycleScrollView2.clipsToBounds = YES;
            
        }
        
    });
    cycleScrollView2.autoScrollTimeInterval = 10000;
    [cycleScrollView2 addSubview:imageViewBg];
    [self.tableView.tableHeaderView addSubview:imageViewBg];
    //    [imageViewBg addSubview:_pageControl];
    
    
}

-(void)getLocalPicLoop
{
    UIImage * aImage = [UIImage imageNamed:@"暂无图片"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(106.5/320.0*kScreenWidth, 135/586.0*kScreenHeight, 107/320.0*kScreenWidth, 37/586.0*kScreenHeight)];
    imageView.image = aImage;
    self.tableView.tableHeaderView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0];
    
    UIImageView *imageViewBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 219/586.0*kScreenHeight, [UIScreen mainScreen].bounds.size.width, 68/586.0*kScreenHeight)];
    UIImage *imageBg = [UIImage imageNamed:@"图片上阴影"];
    imageViewBg.image = imageBg;
    [self.tableView.tableHeaderView addSubview:imageViewBg];
    
    [self.tableView.tableHeaderView addSubview:imageView];
    
    
    
}



#pragma mark - 字典转json串
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

#pragma mark - tabelView dataSource


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    
    if (section == 3) {
        return 55;
    }
    if (section == tableView.numberOfSections - 1   ) {
        return 10;
    }
    return 55;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.baseArray.count == 0) {
        return 	0;
    }
    
    
    
    if (indexPath.section ==3) {
        return 110;
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 35;
            
        }else{
            return 35;
        }
        
        
    }else if(indexPath.section == 1||indexPath.section == 2){
        RecordDetailTableViewCell *cell = (RecordDetailTableViewCell *)[self tableView:self.tableView cellForRowAtIndexPath: indexPath];
        [cell calculateheight];
        return cell.frame.size.height;
        //        return 44;
    }else
    {
        return 44;
    }
    
    
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //    return self.productInfoArray.count + 2;
    return self.textArray.count + 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 ) {
        return self.baseArray.count;
        
    }
    if (section == tableView.numberOfSections - 1) {//最后一个section
        
        
        if (self.url == nil) {
            return 0;
        }else{
            
            return 1;
        }
    }
    
    if(section == 1){
        //        NSLog(@"%lu",[self.productInfoArray.firstObject count]);
        
        return [self.productInfoArray.firstObject count];
    }
    if (section == 3) {//商品评价返回的cell个数;
        return 1;
    }
    
    else  {
        if (self.productInfoArray.count == 1) {
            return 0;
        }else{
            return [self.productInfoArray.lastObject count] ;
        }
    }
}

//字符串转十六进制
- (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    RecordDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[RecordDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if (indexPath.section == 4)
    {//中文标签行
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.titleLabel.textColor = UIColorFromRGB(0x353535);
        
        
        
        
        if (indexPath.row == 0) {
            //            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            if (self.url == nil) {
                cell.hidden = YES;
                
            }else{
                cell.titleLabel.text = @"中文标签";
                cell.titleLabel.frame = CGRectMake(13, 7, 80, 30);
                
                cell.textLabel.text = self.url;
                
                
                
                cell.textLabel.hidden = YES;
                
                //NSLog(@"%@",self.url);
            }
        }
        else if(indexPath.row == 1){
            cell.hidden = YES;
            cell.titleLabel.frame = CGRectMake(13, 7, 80, 30);
            cell.titleLabel.text = @"检验检疫证明";
        }else{
            cell.hidden = YES;
            cell.titleLabel.text = @"其他附件";
        }
        
    }else if(indexPath.section == 0)
    {//产品名称和检疫状态
        BaseModel *baseModel = self.baseArray[indexPath.row];
        if (indexPath.row == 0)
        {
            cell.textLabel.numberOfLines = 0;
#warning 修改
            CGSize size =[cell.textLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
            if (cell.textLabel.text == nil)
            {
                ;//如果cell.textLabel为nil就不添加蓝色盾牌
            }else{
                if ([self.countKey isEqualToString:@"1"])
                {
                    UIImageView * aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(cell.textLabel.frame.origin.x + size.width + 3, 6,12, 14)];
                    if (size.width > 320.0/375.0*kScreenWidth)
                    {
                        size.width = size.width - 25/375.0*kScreenWidth;
                        aImageView.frame =CGRectMake(cell.textLabel.frame.origin.x + size.width + 3, cell.textLabel.frame.origin.y,14, 16);
                    }
                    aImageView.image = [UIImage imageNamed:@"蓝色盾牌"];
                    [cell.contentView addSubview:aImageView];
                    //跳转标识
                    self.key = @"yes";
                    self.countKey = @"2";
                }
            }
            cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
            cell.textLabel.textColor = UIColorFromRGB(0x353535);
            cell.userInteractionEnabled = YES;
        }
#pragma mark - 此处做的变更
        //如果type值为1则展示， type值为2则图片链接
        if ([baseModel.type isEqual:@"1"]) {
            cell.textLabel.text = baseModel.value;
            //如果key值为count，则删除该行
            if ([baseModel.key isEqual:@"Count"]) {
                //NSLog(@"%@",baseModel.value);
                cell.userInteractionEnabled = NO;
                cell.textLabel.text = baseModel.value;
                //NSLog(@"%@",baseModel.value);
                cell.textLabel.font = [UIFont systemFontOfSize:13];
                cell.textLabel.textColor = [UIColor redColor];
                [self.baseArray removeObjectAtIndex:indexPath.row];
                [self.tableView reloadData];
            }if ([baseModel.key isEqual:@"StatusDesc"]) {//商品分为“经检验检疫放行”“不合格”“紧急召回”“检验中”4种状态，其中“不合格”，“紧急召回” “检验中”3种状态标红显示
                cell.textLabel.font = [UIFont systemFontOfSize:13];
                //                if ([baseModel.value isEqual:@"经检验检疫放行"]) {
                NSString *color = baseModel.color;
                NSString * aStr = [NSString stringWithFormat:@"0x%@", color];
                
                //先以16为参数告诉strtoul字符串参数表示16进制数字，然后使用0x%X转为数字类型
                unsigned long value = strtoul([aStr UTF8String],0,16);
                //strtoul如果传入的字符开头是“0x”,那么第三个参数是0，也是会转为十六进制的,这样写也可以：
                //unsigned long red = strtoul([@"0x6587" UTF8String],0,0);
                
                //NSLog(@"转换完的数字为：%lx",value);
#warning 此处可以获得后台传过来的color值，不用判断，
                cell.userInteractionEnabled = NO;
                cell.textLabel.textColor = UIColorFromRGB(value);
                
            }
            cell.textLabel.text = baseModel.value;
            
            
            //            NSLog(@"%@",baseModel.value);
        }
        
        else  {//数据里面可能没有key＝2的数据
            
            
            //如果为2则删除该cell
            [self.baseArray removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        }
        
        
        
        
    }else if(indexPath.section == 1)
    {//基本信息
        //        cell.contentView.backgroundColor = [UIColor cyanColor];
        cell.contentLabel.numberOfLines = 0;
        ProductInfoModel *productModel = self.productInfoArray.firstObject[indexPath.row];
        //如果model里有url链接，则显示">",并且可以进行点击
        if (productModel.url != nil) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.userInteractionEnabled = YES;
            cell.textLabel.text = productModel.url;//将url存入cell.textlabel
            cell.textLabel.hidden = YES;
        }else{
            cell.userInteractionEnabled = NO;
        }
        [cell setTitleLabelText:productModel.text];
        [cell setContentLabelText:productModel.value];
        //CGRect  originFrame = cell.contentLabel.frame;
        cell.contentLabel.numberOfLines = 0;
        [cell calculateheight];//没看明白，以后再研究
        
    }else
    {
        if (self.productInfoArray.count == 1) {
            ;
        }else{
            if (indexPath.section == 3) {
                
                EvaluateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"evalueateID"];
                
                //                  cell.backgroundColor = [UIColor cyanColor];
                cell.starImage.image = [UIImage imageNamed:@"星星"];
                cell.comment.text = @"挺不错的";
                NSString *str = @"18236953178";
                
                NSString *subStr = [str substringWithRange:NSMakeRange(3,4)];
                cell.phoneNumber.text = [str stringByReplacingOccurrencesOfString:subStr withString:@"****"];
                
                cell.date.text = @"2015-01-02";
                [cell.button setTitle:@"查看所有评价" forState:UIControlStateNormal];
                
                [cell.button addTarget:self action:@selector(cellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                //                    cell.userInteractionEnabled = NO;
                //                    cell.backgroundColor = [UIColor cyanColor];
                return cell;
            }else
            {//报检信息
                //section == 2
                ProductInfoModel *productModel = self.productInfoArray.lastObject[indexPath.row];
                if (productModel.url != nil) {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                    cell.userInteractionEnabled = YES;
                    cell.textLabel.text = productModel.url;
                    cell.textLabel.hidden = YES;
                }else{
                    cell.userInteractionEnabled = NO;
                }
                //        cell.titleLabel.text = productModel.text;
                [cell setTitleLabelText:productModel.text];
                [cell setContentLabelText:productModel.value];
            }
        }
        [cell calculateheight];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //cell.selectedBackgroundView.backgroundColor = [UIColor redColor];
    UIView *aView = [[UIView alloc] initWithFrame:cell.contentView.frame];
    aView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    cell.selectedBackgroundView = aView;
    return cell;
    
}
#warning 评价界面跳转还没做
-(void)cellButtonAction:(UIButton *)sender
{
//    NSLog(@"点击了查看所有评价");
//    EvaluateViewController *evaluateVC = [[EvaluateViewController alloc] init];
//    [self.navigationController pushViewController:evaluateVC animated:YES];
    
    
}
#pragma mark - 点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //当手指离开某行时，就让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RecordDetailTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //NSLog(@"%@",cell.textLabel.text);
    
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.url = cell.textLabel.text;
    //NSLog(@"%@",webVC.url);
    if(indexPath.section == 0){
        if (indexPath.row == 0) {
#warning  跳转到指定图片页面
            if ([self.key isEqualToString:@"yes"]) {
                //NSLog(@"点击了产品名");
                webVC.url = @"http://appserver.ciqca.com/appweb/valid.jsp";
                webVC.titleStr = @"已认证";
                [self.navigationController pushViewController:webVC animated:YES];
                //cell.selectionStyle =UITableViewCellSelectionStyleNone;
            }
//            else{
//                cell.userInteractionEnabled = NO;
//                cell.selectionStyle =UITableViewCellSelectionStyleNone;
//                //            IconViewController *iconVC = [[IconViewController alloc] init];
//                //            [self.navigationController pushViewController:iconVC animated:YES];
//            }
        }
        
    }else if (indexPath.section == 3){
        
//        //NSLog(@"点击l第三个section");
//        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
    }
    
    else{
        //NSLog(@"%@",cell.titleLabel.text);
        webVC.titleStr = cell.titleLabel.text;
        [self.navigationController pushViewController:webVC animated:YES];
    }
    
    
    
    
}



#pragma mark - 自定义section

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 25, 100, 30)];//创建一个视图
    //    headerView.backgroundColor = [UIColor redColor];
    if ( section == tableView.numberOfSections - 1 ) {
        
        UIView *View = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 100, 10)];
        View.backgroundColor = UIColorFromRGB(0xf1f1f1);
        //NSLog(@"%lu",(unsigned long)self.sectionArray.count);
        if (self.sectionArray.count < 1) {
            View.backgroundColor = [UIColor whiteColor];
        }
        
        return View;
        
    }
    
    UIImageView *blueImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    UIImage *blueImage = [UIImage imageNamed:@"未标题-1.png"];
    blueImageView.image = blueImage;
    //    [headerImageView setImage:image];
    [headerView addSubview:blueImageView];
    
    
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 20)];
    
    //    headerLabel.backgroundColor = [UIColor greenColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:14];
    headerLabel.textColor = UIColorFromRGB(0x353535);
    NSString *name = self.textArray[section-1];
    //        return name;
    headerLabel.text = name;
    headerLabel.userInteractionEnabled = YES;
    [headerView addSubview:headerLabel];
    
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
        [view addSubview:headerView];
        UIImageView *headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 4, self.view.frame.size.width, 2)];
        UIImage *image = [UIImage imageNamed:@"虚线.png"];
        headerImageView.image = image;
        [view addSubview:headerImageView];
        return view;
    }
    if (section != 1 && section != self.sectionArray.count - 1)
    {
        UIView *View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 55)];
        View.backgroundColor = [UIColor whiteColor];
        UIView *smallView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 10)];
        
        smallView.backgroundColor = UIColorFromRGB(0xf1f1f1);
        
        [View addSubview:smallView];
        [View addSubview:headerView];
        return View;
    }
    
    
    
    return headerView;
    
    
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
