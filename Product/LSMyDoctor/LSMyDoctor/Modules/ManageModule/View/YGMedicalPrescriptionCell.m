//
//  YGMedicalPrescriptionCell.m
//  YouGeHealth
//
//  Created by WangQuanjiang on 2017/11/13.
//
//

#import "YGMedicalPrescriptionCell.h"
#import "UIButton+WebCache.h"


@interface YGMedicalPrescriptionCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;//标题名称
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHeight;//backView的高度

@end

@implementation YGMedicalPrescriptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    self.titleLab.text = titleStr;
}

- (void)setImgArr:(NSMutableArray *)imgArr
{
    _imgArr = imgArr;
    
}
- (void)setValueStr:(NSString *)valueStr
{
    _valueStr = valueStr;
    
    for (UIView* v in self.backView.subviews) {
        [v removeFromSuperview];
    }
    
    UILabel* valueLab = [[UILabel alloc] init];
    valueLab.text = valueStr;
    valueLab.textAlignment = NSTextAlignmentRight;
    valueLab.textColor = UIColorFromRGB(0x686868);
    valueLab.font = [UIFont systemFontOfSize:15.0f];
 //   CGFloat valueLabHeight = [Function contentHeightWithSize:15.0 with:self.backView.bounds.size.width  string:valueStr] ;//文字的高度
    CGFloat valueLabHeight = [valueStr heightWithFont:[UIFont systemFontOfSize:15.0f] constrainedToWidth:self.backView.bounds.size.width];
    [self.backView addSubview:valueLab];
    
    [valueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.backView);
        make.height.equalTo(@(valueLabHeight));
    }];
    
    
    //设置图片
    NSMutableArray* imgMultArr = _imgArr;
    
    CGFloat btnWidth = (self.backView.bounds.size.width - 40)/3;//照片的宽度和高度
    CGFloat imgViewHeight = 0.0;//图片的高度
    
    NSInteger numRow = 1;//取行数，向上取整
    if (imgMultArr.count  >  3) {
        numRow = (NSInteger)ceilf((float)imgMultArr.count/3);
        
        imgViewHeight = numRow * (10 + btnWidth) + 10;
        
    }else{
        imgViewHeight = (10 + btnWidth) + 10;
    }
    
    self.backViewHeight.constant = valueLabHeight + imgViewHeight;//总共显示的高度
    
    for (int i = 0 ; i < 3; i ++) {
        //三行
        for (int j = 0; j < 3; j++) {
            //四列
            WFHelperButton* imgBtn = [[WFHelperButton alloc] initWithFrame:CGRectMake(10 + (btnWidth + 10)*j, valueLabHeight + 10 + (btnWidth + 10) * i, btnWidth, btnWidth)];
            
            imgBtn.index = 3 * i + j;
            imgBtn.layer.masksToBounds = YES;
            imgBtn.layer.cornerRadius = 6.0f;
            imgBtn.layer.borderWidth = 1.0f;
            imgBtn.layer.borderColor = BarColor.CGColor;
            imgBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
            if (3 * i + j >= imgMultArr.count || imgMultArr.count > 9 || imgMultArr.count <= 0){
                imgBtn.hidden = YES;
            }else{
                NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UGAPI_HOST,imgMultArr[3 * i + j]]];
                [imgBtn sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"logo"]];
            }
            
            [self.backView addSubview:imgBtn];
            
        }
        
        
    }
    
    
    if (valueLabHeight <= 30 && imgMultArr.count <= 0) {
        self.backViewHeight.constant = 30.0f;
    }
    
    
    
    
}

@end
