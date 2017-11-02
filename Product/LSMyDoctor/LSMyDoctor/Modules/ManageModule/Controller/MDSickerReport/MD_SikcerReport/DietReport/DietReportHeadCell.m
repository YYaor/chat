//
//  DietReportHeadCell.m
//  YouGeHealth
//
//  Created by yunzujia on 16/11/1.
//
//

#import "DietReportHeadCell.h"

@interface DietReportHeadCell ()

@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;

@end

@implementation DietReportHeadCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHeaderTitle:(NSString *)headerTitle
{
    _headerTitle = headerTitle;
    _headerTitleLabel.text = headerTitle;
}

@end
