//
//  MessageTableViewCell.m
//  BaseProject
//
//  Created by 刘子琨 on 16/4/5.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "MessageTableViewCell.h"

@interface MessageTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation MessageTableViewCell

-(void)setMessageDic:(NSDictionary *)messageDic
{
    _messageDic = messageDic;
    self.titleLabel.text = [NSString stringWithFormat:@"请注意您扫描过的\"%@\"保质期还剩xx天", messageDic[@"productname"]];
    NSString *imageUrl = messageDic[@"imageUrl"];
    NSURL *url = [NSURL URLWithString:imageUrl];
    [self.leftImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon1024"]];
    
    NSDate *date = messageDic[@"firedate"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString *receiveTimeStr = [dateFormatter stringFromDate:date];
    self.timeLabel.text = receiveTimeStr;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
