//
//  PasswordViewController.m
//  CACheck
//
//  Created by 刘子琨 on 16/1/28.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "PasswordViewController.h"
#import "NSString+MD5.h"

@interface PasswordViewController ()

@property (strong,nonatomic)UITextField *oldPasswordTextField;
@property (strong,nonatomic)UITextField *freshPasswordTextField;
@property (strong,nonatomic)UITextField *repeatPasswordTextField;

@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self setNavigationBar];
    [self setInterface];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"修改密码页面"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"修改密码页面"];
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
    label.text = @"修改密码";
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
    
    
    UIButton *leftButton = [[UIButton alloc]init];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backToPersonalInformationViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(80, 44));
    }];
    //手动添加highlight效果
    leftButton.tag = 101;
    [leftButton addTarget:self action:@selector(tapBack:) forControlEvents:UIControlEventTouchDown];
    [leftButton addTarget:self action:@selector(tapUp:) forControlEvents:UIControlEventTouchUpOutside];
    
    UIImage *image = [UIImage imageNamed:@"返回箭头"];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = image;
    [leftButton addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(13);
        make.size.mas_equalTo(CGSizeMake(11, 19));
    }];
    
    UIButton *rightButton = [[UIButton alloc]init];
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightItemAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(50, 44));
    }];
    //手动添加highlight效果
    rightButton.tag = 102;
    [rightButton addTarget:self action:@selector(tapBack:) forControlEvents:UIControlEventTouchDown];
    [rightButton addTarget:self action:@selector(tapUp:) forControlEvents:UIControlEventTouchUpOutside];
    
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

-(void)setInterface
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(81);
        make.left.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 44));
    }];
    
    UILabel *label = [[UILabel alloc]init];
    [view addSubview:label];
    label.text = @"旧密码";
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(70, 24));
    }];
    
    self.oldPasswordTextField = [[UITextField alloc]init];
    self.oldPasswordTextField.placeholder = @"请输入旧密码";
    self.oldPasswordTextField.secureTextEntry = YES;
    [view addSubview:self.oldPasswordTextField];
    [self.oldPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label.mas_right).mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-10);
    }];
    
    
    UIView *freshView = [[UIView alloc]init];
    freshView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:freshView];
    [freshView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_bottom).mas_equalTo(1);
        make.left.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 44));
    }];
    
    UILabel *freshLabel = [[UILabel alloc]init];
    [freshView addSubview:freshLabel];
    freshLabel.text = @"新密码";
    [freshLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(70, 24));
    }];
    
    self.freshPasswordTextField = [[UITextField alloc]init];
    self.freshPasswordTextField.placeholder = @"请输入6位以上密码";
    self.freshPasswordTextField.secureTextEntry = YES;
    [freshView addSubview:self.freshPasswordTextField];
    [self.freshPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label.mas_right).mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-10);
    }];
    
    UIView *repeatView = [[UIView alloc]init];
    repeatView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:repeatView];
    [repeatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(freshView.mas_bottom).mas_equalTo(1);
        make.left.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 44));
    }];
    
    UILabel *repeatLabel = [[UILabel alloc]init];
    [repeatView addSubview:repeatLabel];
    repeatLabel.text = @"重复密码";
    [repeatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(70, 24));
    }];
    
    self.repeatPasswordTextField = [[UITextField alloc]init];
    self.repeatPasswordTextField.placeholder = @"请再次输入";
    self.repeatPasswordTextField.secureTextEntry = YES;
    [repeatView addSubview:self.repeatPasswordTextField];
    [self.repeatPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label.mas_right).mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-10);
    }];

}

-(void)backToPersonalInformationViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightItemAction
{
    if ([self.freshPasswordTextField.text length]<6||[self.freshPasswordTextField.text length]>20) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入6位以上密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        if (![self.freshPasswordTextField.text  isEqualToString: self.repeatPasswordTextField.text] ) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次密码输入不一致" delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil, nil];
            [alert show];
        }else{
            //判断正确走这个方法
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *catoken = [userDefaults stringForKey:@"CA-Token"];
            
            [manager.requestSerializer setValue:catoken forHTTPHeaderField:@"CA-Token"];
            
            
            NSString *url = [NSString stringWithFormat:@"%@/%@",kUrl,kInfoUrl];
            //            NSString *url = @"http://appserver.ciqca.com/modifyappuserapi.action";
            NSString *username = [userDefaults stringForKey:@"username"];
            
            NSString *oldpassword = [self.oldPasswordTextField.text MD5];
            NSString *newpassword = [self.freshPasswordTextField.text MD5];
            
            
            NSDictionary * dic = @{@"username":username,@"olduserpassword":oldpassword,@"userpassword":newpassword,@"roleid":[NSNumber numberWithInt:1],@"status":[NSNumber numberWithInt:1]};
            
            NSString *dicStr = [self dictionaryToJson:dic];
            NSDictionary *paramDic = @{@"json":dicStr};
            
            [manager POST:url parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSString *str = responseObject[@"FailInfo"];
                //                NSInteger *result = responseObject[@"Result"]integerValue;
                if ([responseObject[@"Result"]integerValue] == 0) {
                    [userDefaults setObject:@"修改成功" forKey:@"password"];
                    [self.navigationController popViewControllerAnimated:YES];
                    //                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
            }];
        }
    }

}

//字典转化成json串
- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
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
