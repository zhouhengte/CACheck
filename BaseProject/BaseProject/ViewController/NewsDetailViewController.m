//
//  NewsDetailViewController.m
//  BaseProject
//
//  Created by 刘子琨 on 16/5/11.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "NewsDetailViewController.h"
#import <UMSocial.h>

@interface NewsDetailViewController ()<UIWebViewDelegate,UMSocialUIDelegate>
@property(nonatomic,strong)UIWebView *webView;
@property (nonatomic , strong)UIActivityIndicatorView *activityIndicator;

@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //去除上方留白
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.webView = [[UIWebView alloc]init];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.mas_equalTo(64);
    }];
    self.webView.delegate = self;
    [self.webView loadRequest:self.request];
    self.webView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //重新设置导航栏，隐藏原生导航栏，手动绘制新的导航栏，使右滑手势跳转时能让导航栏跟着变化
    [self setNavigationBar];

}

-(void)setNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1.0];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(21);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1.0];
    label.text = @"新闻知识";
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backToMainViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(80, 44));
    }];
    //手动添加highlight效果
    button.tag = 101;
    [button addTarget:self action:@selector(tapBack:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(tapUp:) forControlEvents:UIControlEventTouchUpOutside];
    
    UIButton *rightButton = [[UIButton alloc]init];
    [rightButton setTitle:@"分享" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(5);
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(80, 44));
    }];
    
    UIImage *image = [UIImage imageNamed:@"返回箭头"];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = image;
    [button addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(13);
        make.size.mas_equalTo(CGSizeMake(11, 19));
    }];
    
    //由于改写了leftBarButtonItem,所以需要重新定义右滑返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
}

-(void)tapBack:(UIButton *)button
{
    button.alpha = 0.5;
}
-(void)tapUp:(UIButton *)button
{
    button.alpha = 1;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"新闻知识详情"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"新闻知识详情"];
}

-(void)share:(UIButton *)sender
{
    NSLog(@"%@",self.webView.request.URL.absoluteString);
    //如果需要分享回调，请将delegate对象设置self，并实现下面的回调方法
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"507fcab25270157b37000010"
                                      shareText:@"TEST"
                                     shareImage:[UIImage imageNamed:@"icon1024"]
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone]
                                       delegate:self];
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

- (void)backToMainViewController:(UIButton *)sender {
    //webView无法后退才跳转到主页面
    if ([self.webView canGoBack]) {
        sender.alpha = 1.0;
        [self.webView goBack];
        
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



#pragma mark --- UIWebViewDelegate
//开始加载网页
- (void)webViewDidStartLoad:(UIWebView *)webView {
    //设置状态条(status bar)的activityIndicatorView开始动画
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    [view setTag:108];
    [view setBackgroundColor:[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1]];
    
    [self.view addSubview:view];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    
    
    [_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    
    [view addSubview:_activityIndicator];
    [_activityIndicator setCenter:CGPointMake(kScreenWidth/2.0, (kScreenHeight-64)/2.0)];
    
    [_activityIndicator startAnimating];
    
}

//成功加载完毕
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self performSelector:@selector(loadEnd) withObject:nil afterDelay:1];
    
}

-(void)loadEnd
{
    //设置indicatorView动画停止
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
}

//加载失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    //停止动画
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
    NSLog(@"加载失败:%@", error.userInfo);
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
