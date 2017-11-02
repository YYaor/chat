//
//  SubPicAttachCollectionCell.m
//  YouGeHealth
//
//  Created by earlyfly on 16/10/20.
//
//
//图片附件题子cell
#import "SubPicAttachCollectionCell.h"


@implementation SubPicAttachCollectionCell

- (void)awakeFromNib {
    // Initialization code
    
        _picBtn.layer.masksToBounds = YES;
        _picBtn.layer.borderColor = BarColor.CGColor;
        _picBtn.layer.borderWidth = 1;
        _picBtn.layer.cornerRadius = 5;
    
}

@end
