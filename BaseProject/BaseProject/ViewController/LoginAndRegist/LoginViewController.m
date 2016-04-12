//
//  LoginViewController.m
//  BaseProject
//
//  Created by 刘子琨 on 16/1/18.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "LoginViewController.h"
#import "NSString+MD5.h"
#import "MainViewController.h"

@interface LoginViewController () <MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
//@property (nonatomic , strong) UIButton *btn;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong,nonatomic) MBProgressHUD *hud;

@property (nonatomic , copy)NSString *passwordMd5;


@end

@implementation LoginViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginButton.backgroundColor = [UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1.0];
    [self.loginButton.layer setCornerRadius:8.0]; //设置矩圆角半径
    
    
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
    label.text = @"登录";
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
    [button addTarget:self action:@selector(backToPreferenceViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"登录页面"];//("PageOne"为页面名称，可自定义)
    
//    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.btn.frame = CGRectMake(0, 0, 80, 44);
//    self.btn.userInteractionEnabled = YES;
//    [self.btn setTitle:@"返回" forState:UIControlStateNormal];
//    UIImage *image = [UIImage imageNamed:@"返回箭头"];
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 13, 11, 19)];
//    
//    imageView.image = image;
//    [self.btn addSubview:imageView];
//    
//    UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:self.btn];
//    self.navigationItem.leftBarButtonItem = back;
//    
//    
//    imageView.userInteractionEnabled = YES;
//    self.btn.userInteractionEnabled = YES;
//    //[self.navigationController.navigationBar addSubview:self.btn];
//    
//    
//    [self.btn addTarget: self action: @selector(backToPreferenceViewController) forControlEvents: UIControlEventTouchUpInside];
//    
//    //由于改写了leftBarButtonItem,所以需要重新定义右滑返回手势
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"登录页面"];
}

//点击空白处，隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.phoneNumTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}


- (IBAction)loginClick:(id)sender {
    NSLog(@"您点击了登录按钮");
    if ([self.phoneNumTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入账号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([self.passwordTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    //  配置hud
    self.hud = [[MBProgressHUD alloc] init];
    self.hud.delegate = self;
    _hud.dimBackground = YES;
    _hud.labelText = @"正在登录";
    [self.view addSubview:_hud];
    [_hud show:YES];
    //[_hud hide:YES afterDelay:3];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    //url
    //    NSString *url = @"http://appserver.ciqca.com/loginapi.action";
    NSString *url = [NSString stringWithFormat:@"%@/%@",kUrl,kLoginUrl];
    //md5
    self.passwordMd5 = [self.passwordTextField.text MD5];
    
    NSDictionary *dic = @{@"username":self.phoneNumTextField.text,@"userpassword":self.passwordMd5};
    NSString *strParam = [self dictionaryToJson:dic];
    NSDictionary *paramDic = @{@"json":strParam};
    
    [manager POST:url parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:responseObject[@"petname"] forKey:@"petname"];
        [userDefaults setValue:responseObject[@"gender"] forKey:@"gender"];
        [userDefaults setValue:responseObject[@"username"] forKey:@"username"];
        [userDefaults setValue:responseObject[@"roleid"] forKey:@"roleid"];
        [userDefaults setValue:responseObject[@"userid"] forKey:@"userid"];
        
        //打印header中的信息
        //NSLog(@"%@",task.response.allHeaderFields);
        //NSString *FailInfo = responseObject[@"FailInfo"];
        
        if ([responseObject[@"Result"]integerValue] == 0) {
            NSLog(@"登录成功");
            
            //将数据存储到NSUserDefautls中，
            [self saveNSUserDefaultsWithResponseObject:responseObject andTask:task];
            //登录成功返回到主页并提示登录成功
            
            
            
            //            self.alert = [[UIAlertView alloc] initWithTitle:nil message:@"登录成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:@"登录成功" forKey:@"login"];
            //设置logout为空，不然主页面会弹出2个hud
            [userDefaults setObject:@"" forKey:@"logout"];
            
            MainViewController *mainVC =[self.storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
            mainVC.from = @"登录成功";
            [self.navigationController pushViewController:mainVC animated:YES];
            //将mainVC设为导航栏唯一页面，使其无法右滑返回
            //[self.navigationController setViewControllers:@[mainVC]];
            
            [self.hud hide:YES];

            
            
        }else {
            [self.hud hide:YES];
            UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert2 show];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"登录失败－－－－－%@",error);
        //  隐藏hud
        [self.hud hide:YES];
    }];
    
    
//    [manager POST:url parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject);
//        
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        [userDefaults setValue:responseObject[@"petname"] forKey:@"petname"];
//        [userDefaults setValue:responseObject[@"gender"] forKey:@"gender"];
//        [userDefaults setValue:responseObject[@"username"] forKey:@"username"];
//        [userDefaults setValue:responseObject[@"roleid"] forKey:@"roleid"];
//        [userDefaults setValue:responseObject[@"userid"] forKey:@"userid"];
//        
//        //打印header中的信息
//        NSLog(@"%@",operation.response.allHeaderFields);
//        NSString *FailInfo = responseObject[@"FailInfo"];
//        
//        if ([responseObject[@"Result"]integerValue] == 0) {
//            NSLog(@"登录成功");
//            
//            //将数据存储到NSUserDefautls中，
//            [self saveNSUserDefaultsWithResponseObject:responseObject andOperation:operation];
//            //登录成功返回到主页并提示登录成功
//            
//            
//            
//            //            self.alert = [[UIAlertView alloc] initWithTitle:nil message:@"登录成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
//            
//            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//            [userDefaults setObject:@"登录成功" forKey:@"login"];
//            
//            ViewController *VC =[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"storyBoardID"];
//            [self.navigationController pushViewController:VC animated:YES];
//            
//            
//            
//            MBProgressHUD *Hud = [[MBProgressHUD alloc] initWithView:self.view];
//            [self.view addSubview:Hud];
//            Hud.labelText = @"登录成功";
//            Hud.labelFont = [UIFont systemFontOfSize:14];
//            Hud.mode = MBProgressHUDModeText;
//            
//            //            hud.yOffset = 250;
//            
//            
//            [Hud showAnimated:YES whileExecutingBlock:^{
//                sleep(3);
//                
//            } completionBlock:^{
//                [Hud removeFromSuperview];
//                
//                
//            }];
//            
//            
//        }else {
//            [hud hide:YES];
//            UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert2 show];
//        }
//        
//        [hud hide:YES];
//        [hud removeFromSuperview];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"登录失败－－－－－%@",error);
//        //  隐藏hud
//        [hud hide:YES];
//        [hud removeFromSuperview];
//        
//    }];

    
}

//hub的内存管理
-(void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud.delegate = nil;
    hud = nil;
}

-(void)backToPreferenceViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 保存数据到NSUserDefaults
-(void)saveNSUserDefaultsWithResponseObject:(id)responseObject andTask:(NSURLSessionTask *)task
{
    
    NSString *username = responseObject[@"username"];
    NSString *userid = responseObject[@"userid"];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
    NSString *caToken = httpResponse.allHeaderFields[@"CA-Token"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    [userDefaults setObject:username forKey:@"username"];
    [userDefaults setObject:userid forKey:@"userid"];
    [userDefaults setObject:self.passwordTextField.text forKey:@"password"];
    [userDefaults setObject:caToken forKey:@"CA-Token"];
    NSLog(@"CA-Token = %@",caToken);
    [userDefaults synchronize];   //这行代码一定要加，虽然有时候不加这一行代码也能保存成功，但是如果程序运行占用比较大的内存的时候不加这行代码，可能会造成无法写入plist文件中
    
}


- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
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
