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
@property (nonatomic,strong) UILabel *duedateLabel;
@end

@implementation DueDateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setDate:(NSDate *)date
{
    _date = date;
    
    NSDate *now = [NSDate date];
    NSTimeInterval timeInterval = [date timeIntervalSinceDate:now];
    if (timeInterval <= 0) {
        //过期
        _duedateLabel.text = @"已过期";
        _duedateLabel.textColor = [UIColor redColor];
        _duedateLabel.font = [UIFont systemFontOfSize:20];
    }else{
        _duedateLabel.textColor = UIColorFromRGB(0x34b5fe);
        int totaldays = ((int)timeInterval)/(3600*24)+1;
        if (totaldays >= 365) {
            int years = totaldays/365;
            int days = totaldays%365;
            NSString *str = [NSString stringWithFormat:@"%d年 %d天",years,days];
            NSMutableAttributedString *dateStr = [[NSMutableAttributedString alloc]initWithString:str];
            NSRange yearRange = [str rangeOfString:@"年"];
            NSRange dayRange = [str rangeOfString:@"天"];
            [dateStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:yearRange];
            [dateStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:dayRange];
            _duedateLabel.attributedText = dateStr;
//        }else if (totaldays >= 30){
//            int mouths = totaldays/30;
//            int days = totaldays%30;
//            NSString *str = [NSString stringWithFormat:@"%d个月 %d天",mouths,days];
//            NSMutableAttributedString *dateStr = [[NSMutableAttributedString alloc]initWithString:str];
//            NSRange mouthRange = [str rangeOfString:@"个月"];
//            NSRange dayRange = [str rangeOfString:@"天"];
//            [dateStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:mouthRange];
//            [dateStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:dayRange];
//            _duedateLabel.attributedText = dateStr;
        }else{
            NSString *str = [NSString stringWithFormat:@"%d天",totaldays];
            NSMutableAttributedString *dateStr = [[NSMutableAttributedString alloc]initWithString:str];
            NSRange dayRange = [str rangeOfString:@"天"];
            [dateStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:dayRange];
            _duedateLabel.attributedText = dateStr;
            if (totaldays <= 10) {
                _duedateLabel.textColor = [UIColor redColor];
            }
        }
    }

}

-(instancetype)initWithFrame:(CGRect)frame andJudgeStr:(NSString *)judgeStr
{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, frame.size.height)];
    
//    UIImageView *backgroundImageView = [[UIImageView alloc]initWithFrame:self.frame];
//    backgroundImageView.image = [UIImage imageNamed:@""];
    self.backgroundColor = [UIColor whiteColor];
    
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
    
    //拿到 存有 所有 推送的数组
    NSArray * notiArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    //遍历这个数组 根据 key 拿到我们想要的 UILocalNotification
    for (UILocalNotification * loc in notiArray) {
        if ([[loc.userInfo objectForKey:@"barcode"] isEqualToString:judgeStr]) {
            //如果该产品已存在推送，显示推送日期
            if ([loc.userInfo objectForKey:@"duedate"]) {
                _datePicker.date = [loc.userInfo objectForKey:@"duedate"];
            }
        }
    }
    
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
    [cancelButton setImage:[UIImage imageNamed:@"叉2"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-12);
        make.size.mas_equalTo(CGSizeMake(38, 34));
    }];
    
    
    
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame andDate:(NSDate *)date
{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, frame.size.height)];
    
    UIImageView *backgroundImageView = [[UIImageView alloc]init];
    backgroundImageView.image = [UIImage imageNamed:@"背景"];
    [self addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self);
        make.bottom.mas_equalTo(48);
    }];
    

    
    UIImageView *imageView = [[UIImageView alloc]init];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        //make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(206, 62));
    }];
    
    UILabel *label = [[UILabel alloc]init];
    [self addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"此商品离过期还有";
    label.font = [UIFont systemFontOfSize:18];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(imageView.mas_top).mas_equalTo(-20);
        make.centerX.mas_equalTo(self);
    }];
    
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image = [UIImage imageNamed:@"闹钟"];

    self.duedateLabel = [[UILabel alloc]init];
    _duedateLabel.textAlignment = NSTextAlignmentCenter;
    _duedateLabel.font = [UIFont systemFontOfSize:27];
    NSDate *now = [NSDate date];
    NSTimeInterval timeInterval = [date timeIntervalSinceDate:now];
    if (timeInterval <= 0) {
        //过期
        _duedateLabel.text = @"已过期";
        _duedateLabel.textColor = [UIColor redColor];
        label.text = @"商品已过期，注意及时处理";
        _duedateLabel.font = [UIFont systemFontOfSize:20];
    }else{
        _duedateLabel.textColor = UIColorFromRGB(0x34b5fe);
        int totaldays = ((int)timeInterval)/(3600*24)+1;
        if (totaldays >= 365) {
            int years = totaldays/365;
            int days = totaldays%365;
            NSString *str = [NSString stringWithFormat:@"%d年 %d天",years,days];
            NSMutableAttributedString *dateStr = [[NSMutableAttributedString alloc]initWithString:str];
            NSRange yearRange = [str rangeOfString:@"年"];
            NSRange dayRange = [str rangeOfString:@"天"];
            [dateStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:yearRange];
            [dateStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:dayRange];
            _duedateLabel.attributedText = dateStr;
//        }else if (totaldays >= 30){
//            int mouths = totaldays/30;
//            int days = totaldays%30;
//            NSString *str = [NSString stringWithFormat:@"%d个月 %d天",mouths,days];
//            NSMutableAttributedString *dateStr = [[NSMutableAttributedString alloc]initWithString:str];
//            NSRange mouthRange = [str rangeOfString:@"个月"];
//            NSRange dayRange = [str rangeOfString:@"天"];
//            [dateStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:mouthRange];
//            [dateStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:dayRange];
//            _duedateLabel.attributedText = dateStr;
        }else{
            
            NSString *str = [NSString stringWithFormat:@"%d天",totaldays];
            NSMutableAttributedString *dateStr = [[NSMutableAttributedString alloc]initWithString:str];
            NSRange dayRange = [str rangeOfString:@"天"];
            [dateStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:dayRange];
            _duedateLabel.attributedText = dateStr;
            if (totaldays <= 10) {
                _duedateLabel.textColor = [UIColor redColor];
            }
        }
        
    }
    [self addSubview:_duedateLabel];
    [_duedateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.mas_equalTo(157);
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(180, 40));
    }];
    
    UIButton *updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [updateButton setTitle:@"修改过期日期" forState:UIControlStateNormal];
    [updateButton setTitleColor:UIColorFromRGB(0x34b5fe) forState:UIControlStateNormal];
    [updateButton addTarget:self action:@selector(updateClick) forControlEvents:UIControlEventTouchUpInside];
    updateButton.layer.borderWidth = 1;
    updateButton.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    [self addSubview:updateButton];
    [updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self);
        make.height.mas_equalTo(48);
    }];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setImage:[UIImage imageNamed:@"叉2"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(24);
        make.right.mas_equalTo(-12);
        make.size.mas_equalTo(CGSizeMake(38, 34));
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

-(void)updateClick
{
    self.updateBlock();
}
@end
