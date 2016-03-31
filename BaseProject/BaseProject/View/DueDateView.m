//
//  DueDataView.m
//  BaseProject
//
//  Created by 刘子琨 on 16/3/31.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "DueDateView.h"

@interface DueDateView ()
@property (nonatomic,strong) UIDatePicker *datePicker;
@end

@implementation DueDateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame andJudgeStr:(NSString *)judgeStr
{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, frame.size.height)];
    
    UIImageView *backgroundImageView = [[UIImageView alloc]initWithFrame:self.frame];
    backgroundImageView.image = [UIImage imageNamed:@""];
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 30, 200, 16);
    label.center = CGPointMake(self.center.x, label.center.y);
    label.font = [UIFont systemFontOfSize:20];
    label.text = @"请设置过期日期";
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 70, 300, 200)];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:86400];
    _datePicker.center = CGPointMake(self.center.x, _datePicker.center.y);
    [self addSubview:_datePicker];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = UIColorFromRGB(0x34b5fe);
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(48);
    }];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setImage:[UIImage imageNamed:@"叉"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-12);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    
    
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame isSetted:(BOOL)isSetted
{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, frame.size.height)];
    
    UIImageView *backgroundImageView = [[UIImageView alloc]initWithFrame:self.frame];
    backgroundImageView.image = [UIImage imageNamed:@"背景"];
    [self addSubview:backgroundImageView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 200, 60)];
    imageView.image = [UIImage imageNamed:@"闹钟"];
    [self addSubview:imageView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setImage:[UIImage imageNamed:@"叉"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(34);
        make.right.mas_equalTo(-12);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    return self;
}


-(void)confirmClick
{
    //NSLog(@"确认到期日期:%@",self.datePicker.date);
    self.confirmBlock(self.datePicker.date);
}

-(void)cancelClick
{
    self.cancelBlock();
}

-(void)closeClick
{
    self.closeBlock();
}


@end
