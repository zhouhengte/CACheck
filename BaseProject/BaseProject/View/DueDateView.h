//
//  DueDataView.h
//  BaseProject
//
//  Created by 刘子琨 on 16/3/31.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DueDateView : UIView

@property (nonatomic,copy)void (^cancelBlock)();
@property (nonatomic,copy)void (^confirmBlock)(NSDate *pickDate);
@property (nonatomic,copy)void (^closeBlock)();
@property (nonatomic,copy)void (^updateBlock)();

-(instancetype)initWithFrame:(CGRect)frame andJudgeStr:(NSString *)judgeStr;
-(instancetype)initWithFrame:(CGRect)frame andDate:(NSDate *)date;

@end