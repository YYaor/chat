//
//  MDCheckInfoCell.m
//  MyDoctor
//
//  Created by 惠生 on 17/5/18.
//  Copyright © 2017年 惠生. All rights reserved.
//

#import "MDCheckInfoCell.h"
@interface MDCheckInfoCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;//姓名
@property (weak, nonatomic) IBOutlet UILabel *hospitalNameLab;//医院名称
@property (weak, nonatomic) IBOutlet UILabel *projectLab;//科室

@property (weak, nonatomic) IBOutlet UILabel *sureInfoLab;//确认信息


@end

@implementation MDCheckInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataDict:(NSDictionary *)dataDict
{
    _dataDict = dataDict;
    NSLog(@"%@",dataDict);
    
    if (dataDict[@"footer"]) {
        _sureInfoLab.text = dataDict[@"footer"];
    }
    if (dataDict[@"content"] && [dataDict[@"content"] isKindOfClass:[NSArray class]]) {
        NSArray * dataArr = dataDict[@"content"];
        //姓名
        if (dataArr[0]) {
            NSString* dataNameStr = dataArr[0];
            NSRange range = [dataNameStr rangeOfString:@"："];
            if (range.length != 0) {
                NSString* nameStr = [dataNameStr substringFromIndex:range.location + 1];
                NSLog(@"%@",nameStr);
                self.nameLab.text = nameStr;
            }
        }
        //医院名称
        if (dataArr[1]) {
            NSString* dataNameStr = dataArr[1];
            NSRange range = [dataNameStr rangeOfString:@"："];
            if (range.length != 0) {
                NSString* valueStr = [dataNameStr substringFromIndex:range.location + 1];
                NSLog(@"%@",valueStr);
                self.hospitalNameLab.text = valueStr;
            }
        }
        //科室
        //医院名称
        if (dataArr[2]) {
            NSString* dataNameStr = dataArr[2];
            NSRange range = [dataNameStr rangeOfString:@"："];
            if (range.length != 0) {
                NSString* valueStr = [dataNameStr substringFromIndex:range.location + 1];
                NSLog(@"%@",valueStr);
                self.projectLab.text = valueStr;
            }
        }
        
        
        
    }
    
    
    
    
}

@end
