//
//  CommentViewController.m
//  BaseProject
//
//  Created by 刘子琨 on 16/4/25.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "CommentViewController.h"
#import "LoginViewController.h"

@interface CommentViewController ()
@property (nonatomic,strong)UITextField *textField;
@property (nonatomic,strong)UIView *editView;
@property (nonatomic,strong)UIView *grayTranslucentView;
@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //重新设置导航栏，隐藏原生导航栏，手动绘制新的导航栏，使右滑手势跳转时能让导航栏跟着变化
    [self setNavigationBar];
    
    [self setBottom];
    
    [self setEditView];
    
    
    //增加键盘的弹起通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    //增加键盘的收起通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    
}

// 有键盘弹起,此方法就会被自动执行
-(void)openKeyboard:(NSNotification *)noti
{
    // 获取键盘的 frame 数据
    CGRect  keyboardFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 获取键盘动画的种类
    int options = [noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    // 获取键盘动画的时长
    NSTimeInterval duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 在动画内调用 layoutIfNeeded 方法
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        [self.editView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(94);
            make.bottom.mas_equalTo(-keyboardFrame.size.height);
        }];
        [self.editView layoutIfNeeded];
        
    } completion:nil];
    
}

-(void)closeKeyboard:(NSNotification *)noti
{
    self.grayTranslucentView.hidden = YES;
    // 获取键盘动画的种类
    int options = [noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    // 获取键盘动画的时长
    NSTimeInterval duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 在动画内调用 layoutIfNeeded 方法
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        [self.editView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(94);
            make.bottom.mas_equalTo(94);
        }];
        [self.view layoutIfNeeded];
    } completion:nil];
    
}


// 点击空白处,收起键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
    label.text = @"评价";
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
    [button addTarget:self action:@selector(backToRecordDetailViewController:) forControlEvents:UIControlEventTouchUpInside];
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

-(void)setBottom
{
    UIView *view = [[UIView alloc]init];
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor colorWithRed:199/255.0 green:199/255.0 blue:199/255.0 alpha:1].CGColor;
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(60);
    }];
    
    UIView *centerView = [[UIView alloc]init];
    centerView.layer.borderWidth = 1;
    centerView.layer.cornerRadius = 6;
    centerView.layer.borderColor = [UIColor colorWithRed:174/255.0 green:174/255.0 blue:174/255.0 alpha:1].CGColor;
    [view addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(12.5, 12.5, 12.5, 12.5));
    }];
    centerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
    [centerView addGestureRecognizer:tap];
    
    UIImageView *imageView =[[UIImageView alloc]init];
    [imageView setImage:[UIImage imageNamed:@"评论"]];
    [centerView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(9);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"快来抢第一条评价吧！";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1];
    [centerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(31);
        make.top.right.bottom.mas_equalTo(0);
    }];
}

-(void)tapBack:(UIButton *)button
{
    button.alpha = 0.5;
}
-(void)tapUp:(UIButton *)button
{
    button.alpha = 1;
}

-(void)click:(UIView *)sender
{
    NSLog(@"点击了评价");
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"login"] isEqualToString: @"登录成功"]) {
        NSLog(@"已登陆");
        self.grayTranslucentView.hidden = NO;
        [self.textField becomeFirstResponder];
        
        
    }else{
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self.navigationController pushViewController:[mainStoryBoard instantiateViewControllerWithIdentifier:@"loginViewController"] animated:YES];
    }
}

-(void)setEditView
{
    self.grayTranslucentView = [[UIView alloc]init];
    _grayTranslucentView.frame = self.view.frame;
    _grayTranslucentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self.view addSubview:_grayTranslucentView];
    _grayTranslucentView.hidden = YES;
    
    self.editView = [[UIView alloc]init];
    self.editView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:249/255.0 alpha:1];
    [self.view addSubview:self.editView];
    [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(94);
        make.bottom.mas_equalTo(94);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"轻点星形来评分";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1];
    [self.editView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(51);
    }];
    
    UIButton *firstStar = [[UIButton alloc]init];
    [firstStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
    [self.editView addSubview:firstStar];
    [firstStar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(label);
        make.left.mas_equalTo(label.mas_right).mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    UIButton *secondStar = [[UIButton alloc]init];
    [secondStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
    [self.editView addSubview:secondStar];
    [secondStar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(label);
        make.left.mas_equalTo(firstStar.mas_right).mas_equalTo(25);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    UIButton *thirdStar = [[UIButton alloc]init];
    [thirdStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
    [self.editView addSubview:thirdStar];
    [thirdStar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(label);
        make.left.mas_equalTo(secondStar.mas_right).mas_equalTo(25);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    UIButton *forthStar = [[UIButton alloc]init];
    [forthStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
    [self.editView addSubview:forthStar];
    [forthStar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(label);
        make.left.mas_equalTo(thirdStar.mas_right).mas_equalTo(25);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    UIButton *fifthStar = [[UIButton alloc]init];
    [fifthStar setImage:[UIImage imageNamed:@"点击的评分1"] forState:UIControlStateNormal];
    [self.editView addSubview:fifthStar];
    [fifthStar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(label);
        make.left.mas_equalTo(forthStar.mas_right).mas_equalTo(25);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    UIView *textView = [[UIView alloc]init];
    textView.backgroundColor = [UIColor whiteColor];
    textView.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    textView.layer.borderWidth = 1;
    textView.layer.cornerRadius = 4;
    textView.layer.masksToBounds = YES;
    [self.editView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.bottom.mas_equalTo(-8);
        make.right.mas_equalTo(-46);
        make.height.mas_equalTo(35);
    }];
    
    self.textField = [[UITextField alloc]init];
    [textView addSubview:_textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(9);
        make.bottom.right.top.mas_equalTo(0);
    }];
    _textField.placeholder = @"快来抢第一条评价吧！";
    _textField.font = [UIFont systemFontOfSize:14];
    
    UIButton *button = [[UIButton alloc]init];
    [self.editView addSubview:button];
    [button setTitle:@"发送" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_textField);
        make.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(46, 35));
    }];

}

-(void)backToRecordDetailViewController:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//view看不见时,取消注册的键盘监听
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //取消注册过的通知
    //只按照通知的名字,取消掉具体的某个通知,而不是全部一次性取消掉所有注册过的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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
