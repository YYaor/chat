//
//  LSMessageCell.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/28.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSMessageCell.h"

@interface LSMessageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *unreadLabel;

@end

@implementation LSMessageCell

-(void)setConversation:(EMConversation *)conversation
{
    _conversation = conversation;
 
    EaseMessageModel *messageModel = [[EaseMessageModel alloc]initWithMessage:conversation.latestMessage];
    
    self.nameLabel.text = messageModel.message.conversationId;
    self.messageLabel.text = messageModel.text;
    self.timeLabel.text = [self getChatTime:[NSString stringWithFormat:@"%lld",messageModel.message.timestamp]];

    self.headImageView.image = messageModel.avatarImage;
    if (conversation.unreadMessagesCount == 0) {
        self.unreadLabel.hidden = YES;
    }else{
        self.unreadLabel.hidden = NO;
        self.unreadLabel.text = [NSString stringWithFormat:@"%d",conversation.unreadMessagesCount];
    }
}

-(NSString *) getChatTime:(NSString*) time{
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *inputDate = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]/1000];
    
    NSString *inputDateStr = [inputFormatter stringFromDate:inputDate];
    NSString *today = [inputDateStr substringToIndex:10];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    NSString *yesterdayStr = [inputFormatter stringFromDate:yesterday];
    
    NSDate *beforeDate = [NSDate dateWithTimeIntervalSinceNow:-(48*60*60)];
    NSString *beforeDateStr = [inputFormatter stringFromDate:beforeDate];
    
    NSString *currentDateStr = [inputFormatter stringFromDate:[NSDate date]];
    
    
    if ([currentDateStr isEqualToString:today]){
        return [inputDateStr substringFromIndex:11];
    } else if ([yesterdayStr isEqualToString:today]){
        return @"昨天";
    } else if ([beforeDateStr isEqualToString:today]){
        return @"前天";
    } else {
        return [today substringFromIndex:5];
    }
}

@end
