//
//  WFSegTitleView.m
//  YouGeHealth
//
//  Created by earlyfly on 16/10/18.
//
//

#import "WFSegTitleView.h"

static const int btnTag = 1100;

#define ViewW self.frame.size.width
#define viewH self.frame.size.height

@interface WFSegTitleView ()<UIScrollViewDelegate>
{
    //效应消息的对象
    id _target;
    //消息
    SEL _action;
    //滑块
    UIView * _sliderView;
    //按钮数
    NSUInteger _num;
    
    NSInteger _defaultIndex;
}

@property(nonatomic,strong) UIScrollView* scroll;

//保存items
@property(nonatomic,strong) NSArray* items;

@property (nonatomic,assign) BOOL isHasLayoutSubViews;

@end


@implementation WFSegTitleView


-(instancetype)initWithItems:(NSArray *)items{
    if (self = [super init]) {
        _items = items;
        //默认选中色
        _selectedColor = BarColor;
        _defaultIndex = -1;
        
        _showLine = NO;//默认不显示分割线
        
        _num = items.count;
        
        self.backgroundColor  = [UIColor whiteColor];
        
    }
    return self;
}



-(void)creatUI{
    [self addSubview:self.scroll];
    
    if (_numOfScreenW == 0) {
        _numOfScreenW = 4;
    }
    CGFloat btnW = kScreenWidth/_numOfScreenW;
    
    self.scroll.contentSize = CGSizeMake(btnW*_num, 0);
    
    //    __weak typeof(self) weakSelf = self;
    [_items enumerateObjectsUsingBlock:^(id   obj, NSUInteger idx, BOOL *  stop) {
        UIButton* btn  = [[UIButton alloc] initWithFrame:CGRectMake(idx*btnW, 0, btnW, viewH)];
        
        //[btn setTitleColor:_selectedColor forState:UIControlStateSelected];
        if (idx == 0) {
            [btn setTitleColor:BarColor forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:UIColorFromRGB(0x212121) forState:UIControlStateNormal];
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.scroll addSubview:btn];
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onclicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = idx + btnTag;
        
        if (self.showLine) {
            //如果要显示分割线
            for (int i = 0; i <= _items.count ; i++) {
                //中间分割线
                UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(btnW *i, 0, 1, viewH)];
                if (i == _items.count) {
                    CGRect frame = lable.frame;
                    frame.size.width = 2;
                    lable.frame = frame;
                    
                }
                lable.backgroundColor = UIColorFromRGB(0xc7c7cd);
                [self.scroll addSubview:lable];
            }
            
            UILabel * bottomLable = [[UILabel alloc] initWithFrame:CGRectMake(0, viewH - 1, btnW, 1)];
            bottomLable.backgroundColor = UIColorFromRGB(0xc7c7cd);
            [btn addSubview:bottomLable];
        }
        
        
    }];
    
    //===============创建底部的线================
    //    CGFloat LH = 1.5;
    //    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, viewH - LH, self.frame.size.width, LH)];
    //    line.backgroundColor = [UIColor lightGrayColor];
    //    [self addSubview:line];
    
    CGFloat SW = btnW;
    CGFloat SH = 2;
    _sliderView = [[UIView alloc] initWithFrame:CGRectMake(0, viewH - SH, SW, SH)];
    _sliderView.backgroundColor = _selectedColor;
    [self addSubview:_sliderView];
    
//    UIButton* right = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - rightBtnWidth, 0, rightBtnWidth, viewH)];
//    [self addSubview:right];
//    [right setImage:[[UIImage imageNamed:@"RB_BUY_arrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//    [right addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - 滚动视图
-(UIScrollView *)scroll{
    if (_scroll == nil) {
        _scroll = [[UIScrollView alloc] init];
        _scroll.showsHorizontalScrollIndicator = NO;
        _scroll.showsVerticalScrollIndicator = NO;
        _scroll.bounces = NO;
        _scroll.frame = CGRectMake(0, 0, ViewW,viewH);
        //        _scroll.backgroundColor = [UIColor greenColor];
        _scroll.delegate = self;
    }
    return _scroll;
}


-(void)layoutSubviews{
    
    if (!_isHasLayoutSubViews) {
        [self creatUI];
        _isHasLayoutSubViews = YES;
    }
    if (_defaultIndex != -1) {
        self.selectedSegmentIndex = _defaultIndex;
    }
}

#pragma mark - 按钮点击
- (void)onclicked:(UIButton *)button{
    
    self.selectedSegmentIndex = button.tag - btnTag;
    
}
#pragma mark - 添加事件
-(void)addTarget:(id)target action:(SEL)action{
    _target = target;
    _action = action;
}
#pragma mark -- 回传值，显示第几块儿
- (void)tabDidSelectTabAtIndex:(NSInteger)index{
    NSLog(@"调到第%ld块儿",(long)index);
    
    _defaultIndex = index;
}

-(void)setSelectedSegmentIndex:(NSUInteger)selectedSegmentIndex{
    

    //通过选中下标拿到当前选中的按钮
    UIButton * selectedBtn = (UIButton *)[self viewWithTag:_selectedSegmentIndex + btnTag];
    //将之前选中的变成非选中状态
    [selectedBtn setTitleColor:UIColorFromRGB(0x212121) forState:UIControlStateNormal];
    selectedBtn.selected = NO;
    //让按钮可以点击
    selectedBtn.userInteractionEnabled = YES;
    
    _selectedSegmentIndex = selectedSegmentIndex;
    
    //将选中下标对应的按钮变成选中状态
    UIButton * btn = (UIButton *)[self viewWithTag:_selectedSegmentIndex + btnTag];
    //设置成选中状态
    [btn setTitleColor:BarColor forState:UIControlStateNormal];
    btn.selected = YES;
    //关闭用户交互
    btn.userInteractionEnabled = NO;
    
    
    
    NSUInteger theIndex = selectedSegmentIndex +  1;
    CGFloat btnW  = kScreenWidth/_numOfScreenW;
    
    if (theIndex*btnW > self.scroll.frame.size.width) {
        CGFloat X = theIndex* btnW - self.scroll.frame.size.width;
        [UIView animateWithDuration:0.1f animations:^{
            self.scroll.contentOffset = CGPointMake(X,0);
        }];
    }else{
        [UIView animateWithDuration:0.1f animations:^{
            self.scroll.contentOffset = CGPointMake(0,0);
        }];
    }
    //改变滑块的中心点
    CGFloat X = self.scroll.contentOffset.x;
    [UIView animateWithDuration:0.3f animations:^{
        _sliderView.center = CGPointMake(btn.center.x - X, self.frame.size.height - _sliderView.frame.size.height/2.0f);
    }];
    
    //3.选中下标的值发生改变，让效应消息的对象去效应消息
    //先判断事件对应的方法有没有实现
    if ([_target respondsToSelector:_action]) {
        
        [_target performSelector:_action withObject:self];
        
    }else{
        
        NSLog(@"警告:事件方法没有实现");
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    static CGFloat lastX = 0;
    
    //    NSLog(@"%f",scrollView.contentOffset.x);
    CGRect rect = _sliderView.frame;
    rect.origin.x = rect.origin.x - (scrollView.contentOffset.x - lastX);
    
    lastX = scrollView.contentOffset.x;
    
    _sliderView.frame = rect;
}

//-(void)rightClick:(UIButton*)right{
//    if ([self.delegate respondsToSelector:@selector(showAllInfo)]) {
//        [self.delegate showAllInfo];
//    }
//}

@end
