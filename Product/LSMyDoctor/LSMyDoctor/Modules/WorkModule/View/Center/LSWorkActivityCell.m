//
//  LSWorkActivityCell.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/11/21.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkActivityCell.h"

@interface LSWorkActivityCell ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *activity_time;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *create_time;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIView *deleteView;

@property (nonatomic, strong) NSDictionary *data;

@end

@implementation LSWorkActivityCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.deleteView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    
    [self.deleteView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearView)]];
    [self.contentView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGester:)]];
    self.deleteView.hidden = YES;
}


- (void)setDataWithDictionary:(NSDictionary *)dic
{
    self.name.text = dic[@"name"];
    self.address.text = dic[@"address"];
    self.activity_time.text = dic[@"activity_time"];
    self.content.text = dic[@"content"];
    self.create_time.text = dic[@"create_time"];
    
    if (dic[@"status"])
    {
        //服务器返回
        if ([dic[@"status"] longValue] == 0)
        {
            self.status.text = @"已过期";
        }
        else if ([dic[@"status"] longValue] == 1)
        {
            self.status.text = @"发布";
        }
    }
    else
    {
        //草稿
        self.status.text = @"草稿";
    }
    
    self.data = dic;
}

- (void)longGester:(UILongPressGestureRecognizer *)sender
{
    self.deleteView.hidden = NO;
}

- (IBAction)deleteButtonClick:(UIButton *)sender
{
    if (self.deleteBlock) {
        self.deleteBlock(self.data);
        self.deleteView.hidden = YES;
    }
    //删除按钮
}
- (void)clearView
{
    self.deleteView.hidden = YES;
}

@end
