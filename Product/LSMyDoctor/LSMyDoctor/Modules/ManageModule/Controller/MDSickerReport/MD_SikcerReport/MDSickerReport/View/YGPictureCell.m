//
//  YGPictureCell.m
//  YouGeHealth
//
//  Created by 惠生 on 16/11/11.
//
//

#import "YGPictureCell.h"
#import "CureSelCollectionViewCell.h"
#import "SubPicAttachCollectionCell.h"

#define cellHeight 40

@interface YGPictureCell ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UILabel *pictureNameLabel;//图片

@property (weak, nonatomic) IBOutlet UICollectionView *picktureColectionView;//放置图片CollectionView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colHeight;

@end

@implementation YGPictureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _picktureColectionView.delegate = self;
    _picktureColectionView.dataSource = self;
    //注册cell
    [_picktureColectionView registerNib:[UINib nibWithNibName:@"CureSelCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"multiSel"];
    //注册cell
    [_picktureColectionView registerNib:[UINib nibWithNibName:@"SubPicAttachCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"subPicAttach"];
    if (kScreenWidth > 375) {
        _pictureNameLabel.font = [UIFont systemFontOfSize:19];
    }
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setMutArr:(NSMutableArray *)mutArr
{
    _mutArr = mutArr;
    
    CGFloat numRow = 1;//取行数，向上取整
    if (mutArr.count >= 4) {
        numRow = ceilf(mutArr.count/4);
    }
    
    self.colHeight.constant = numRow * (kScreenWidth - 69)/4 +  20;
    
    
    [_picktureColectionView reloadData];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.mutArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SubPicAttachCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"subPicAttach" forIndexPath:indexPath];
    
    NSString *url = self.mutArr[indexPath.row];
    UIImage *image = nil;
    if ([url containsString:@"http://"]) {
        
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    }else{
        
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UGAPI_HOST,url]]]];
    }
    if (image == nil) {
        image = [UIImage imageNamed:@"logo"];
    }
    cell.deleteBtn.hidden = YES;
    cell.picBtn.userInteractionEnabled = NO;
    if (image) {
        
        [cell.picBtn setImage:image forState:UIControlStateNormal];
        
    }
//    [cell.picBtn removeTarget:self action:@selector(addPicture) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((kScreenWidth - 69)/4, (kScreenWidth - 69)/4);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 5, 0, 5);
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击图片第%ld张",(long)indexPath.row);
    NSString* urlString = [NSString stringWithFormat:@"%@%@",UGAPI_HOST,self.mutArr[indexPath.row]];
    SubPicAttachCollectionCell *cell = (SubPicAttachCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    //返回url，后面可直接调取
    [self.delegate yGPictureCellDetailBtnClickWithUrl:urlString image:cell.picBtn.currentImage];
    

    
    
    
}



@end
