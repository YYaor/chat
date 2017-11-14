/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "EaseChatBarMoreView.h"

#define CHAT_BUTTON_SIZE CGSizeMake(50,60)
#define INSETS 10
#define MOREVIEW_COL 4
#define MOREVIEW_ROW 2
#define MOREVIEW_BUTTON_TAG 1000

@implementation UIView (MoreView)

- (void)removeAllSubview
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

@end

@interface EaseChatBarMoreView ()<UIScrollViewDelegate>
{
    EMChatToolbarType _type;
    NSInteger _maxIndex;
}

@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIButton *commonlanguageCallButton;//常用语
@property (nonatomic, strong) UIButton *photoCallButton;//照片
@property (nonatomic, strong) UIButton *issueadviceCallButton;//下达医嘱
@property (nonatomic, strong) UIButton *articlerecommendCallButton;//文章推荐
@property (nonatomic, strong) UIButton *questionnaireCallButton;//调查表


@end

@implementation EaseChatBarMoreView

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    EaseChatBarMoreView *moreView = [self appearance];
    moreView.moreViewBackgroundColor = [UIColor whiteColor];
}

- (instancetype)initWithFrame:(CGRect)frame type:(EMChatToolbarType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _type = type;
        [self setupSubviewsForType:_type];
    }
    return self;
}

- (void)setupSubviewsForType:(EMChatToolbarType)type
{
    //self.backgroundColor = [UIColor clearColor];
    self.accessibilityIdentifier = @"more_view";
    
    _scrollview = [[UIScrollView alloc] init];
    _scrollview.pagingEnabled = YES;
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.showsVerticalScrollIndicator = NO;
    _scrollview.delegate = self;
    [self addSubview:_scrollview];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = 1;
    [self addSubview:_pageControl];
    
    CGFloat insets = (self.frame.size.width - 4 * CHAT_BUTTON_SIZE.width) / 5;
    
    _commonlanguageCallButton = [self btnWithImage:[UIImage imageNamed:@"add_commonlanguage"]
                        highlightedImage:[UIImage imageNamed:@"add_commonlanguage"]
                                   title:@"常用语"];
    _commonlanguageCallButton.accessibilityIdentifier = @"commonlanguageCallButton";
    [_commonlanguageCallButton setFrame:CGRectMake(insets, 10, CHAT_BUTTON_SIZE.width , CHAT_BUTTON_SIZE.height)];
    [_commonlanguageCallButton addTarget:self action:@selector(commonlanguageCallButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _commonlanguageCallButton.tag = MOREVIEW_BUTTON_TAG;
    [_scrollview addSubview:_commonlanguageCallButton];
    
    _photoCallButton = [self btnWithImage:[UIImage imageNamed:@"add_photo"]
                     highlightedImage:[UIImage imageNamed:@"add_photo"]
                                title:@"照片"];

    _photoCallButton.accessibilityIdentifier = @"photoCallButton";
    [_photoCallButton setFrame:CGRectMake(insets * 2 + CHAT_BUTTON_SIZE.width, 10, CHAT_BUTTON_SIZE.width , CHAT_BUTTON_SIZE.height)];
    [_photoCallButton addTarget:self action:@selector(photoCallButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _photoCallButton.tag = MOREVIEW_BUTTON_TAG + 1;
    [_scrollview addSubview:_photoCallButton];
    
    
    _issueadviceCallButton = [self btnWithImage:[UIImage imageNamed:@"add_issueadvice"]
                       highlightedImage:[UIImage imageNamed:@"add_issueadvice"]
                                  title:@"下达医嘱"];
    [_issueadviceCallButton setFrame:CGRectMake(insets * 3 + CHAT_BUTTON_SIZE.width * 2, 10, CHAT_BUTTON_SIZE.width , CHAT_BUTTON_SIZE.height)];
    [_issueadviceCallButton addTarget:self action:@selector(issueadviceCallButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _issueadviceCallButton.tag = MOREVIEW_BUTTON_TAG + 2;
    _maxIndex = 2;
    [_scrollview addSubview:_issueadviceCallButton];

    CGRect frame = self.frame;
    if (type == EMChatToolbarTypeChat) {
        frame.size.height = 150;
        _articlerecommendCallButton = [self btnWithImage:[UIImage imageNamed:@"add_articlerecommend"]
                             highlightedImage:[UIImage imageNamed:@"add_articlerecommend"]
                                        title:@"文章推荐"];
        [_articlerecommendCallButton setFrame:CGRectMake(insets * 4 + CHAT_BUTTON_SIZE.width * 3, 10, CHAT_BUTTON_SIZE.width , CHAT_BUTTON_SIZE.height)];
        [_articlerecommendCallButton addTarget:self action:@selector(articlerecommendCallButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _articlerecommendCallButton.tag = MOREVIEW_BUTTON_TAG + 3;
        [_scrollview addSubview:_articlerecommendCallButton];
        
        _questionnaireCallButton = [self btnWithImage:[UIImage imageNamed:@"add_questionnaire"]
                             highlightedImage:[UIImage imageNamed:@"add_questionnaire"]
                                        title:@"调查表"];
        [_questionnaireCallButton setFrame:CGRectMake(insets, 10 * 2 + CHAT_BUTTON_SIZE.height + 10, CHAT_BUTTON_SIZE.width , CHAT_BUTTON_SIZE.height)];
        [_questionnaireCallButton addTarget:self action:@selector(questionnaireCallButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _questionnaireCallButton.tag =MOREVIEW_BUTTON_TAG + 4;
        _maxIndex = 4;
        [_scrollview addSubview:_questionnaireCallButton];
    }
    else if (type == EMChatToolbarTypeGroup)
    {
        frame.size.height = 80;
    }
    self.frame = frame;
    _scrollview.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    _pageControl.frame = CGRectMake(0, CGRectGetHeight(frame) - 20, CGRectGetWidth(frame), 20);
    _pageControl.hidden = _pageControl.numberOfPages<=1;
}


- (UIButton *)btnWithImage:(UIImage *)aImage highlightedImage:(UIImage *)aHighLightedImage title:(NSString *)aTitle {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:aImage forState:UIControlStateNormal];
    [btn setImage:aHighLightedImage forState:UIControlStateHighlighted];
    [btn setTitle:aTitle forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    btn.imageEdgeInsets = UIEdgeInsetsMake(-10, 0, 20, 0);
    btn.titleEdgeInsets = UIEdgeInsetsMake(14, -60, -20, 0);
    return btn;
}

- (void)insertItemWithImage:(UIImage *)image highlightedImage:(UIImage *)highLightedImage title:(NSString *)title
{
    CGFloat insets = (self.frame.size.width - MOREVIEW_COL * CHAT_BUTTON_SIZE.width) / 5;
    CGRect frame = self.frame;
    _maxIndex++;
    NSInteger pageSize = MOREVIEW_COL*MOREVIEW_ROW;
    NSInteger page = _maxIndex/pageSize;
    NSInteger row = (_maxIndex%pageSize)/MOREVIEW_COL;
    NSInteger col = _maxIndex%MOREVIEW_COL;
    UIButton *moreButton = [self btnWithImage:image highlightedImage:highLightedImage title:title];
    [moreButton setFrame:CGRectMake(page * CGRectGetWidth(self.frame) + insets * (col + 1) + CHAT_BUTTON_SIZE.width * col, INSETS + INSETS * 2 * row + CHAT_BUTTON_SIZE.height * row, CHAT_BUTTON_SIZE.width , CHAT_BUTTON_SIZE.height)];
    [moreButton setImage:image forState:UIControlStateNormal];
    [moreButton setImage:highLightedImage forState:UIControlStateHighlighted];
    [moreButton addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    moreButton.tag = MOREVIEW_BUTTON_TAG+_maxIndex;
    [_scrollview addSubview:moreButton];
    [_scrollview setContentSize:CGSizeMake(CGRectGetWidth(self.frame) * (page + 1), CGRectGetHeight(self.frame))];
    [_pageControl setNumberOfPages:page + 1];
    if (_maxIndex >=5) {
        frame.size.height = 150;
        _scrollview.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        _pageControl.frame = CGRectMake(0, CGRectGetHeight(frame) - 20, CGRectGetWidth(frame), 20);
    }
    self.frame = frame;
    _pageControl.hidden = _pageControl.numberOfPages<=1;
}

- (void)updateItemWithImage:(UIImage *)image highlightedImage:(UIImage *)highLightedImage title:(NSString *)title atIndex:(NSInteger)index
{
    UIView *moreButton = [_scrollview viewWithTag:MOREVIEW_BUTTON_TAG+index];
    if (moreButton && [moreButton isKindOfClass:[UIButton class]]) {
        [(UIButton*)moreButton setImage:image forState:UIControlStateNormal];
        [(UIButton*)moreButton setImage:highLightedImage forState:UIControlStateHighlighted];
    }
}

- (void)removeItematIndex:(NSInteger)index
{
    UIView *moreButton = [_scrollview viewWithTag:MOREVIEW_BUTTON_TAG+index];
    if (moreButton && [moreButton isKindOfClass:[UIButton class]]) {
        [self _resetItemFromIndex:index];
        [moreButton removeFromSuperview];
    }
}

#pragma mark - private

- (void)_resetItemFromIndex:(NSInteger)index
{
    CGFloat insets = (self.frame.size.width - MOREVIEW_COL * CHAT_BUTTON_SIZE.width) / 5;
    CGRect frame = self.frame;
    for (NSInteger i = index + 1; i<_maxIndex + 1; i++) {
        UIView *moreButton = [_scrollview viewWithTag:MOREVIEW_BUTTON_TAG+i];
        if (moreButton && [moreButton isKindOfClass:[UIButton class]]) {
            NSInteger moveToIndex = i - 1;
            NSInteger pageSize = MOREVIEW_COL*MOREVIEW_ROW;
            NSInteger page = moveToIndex/pageSize;
            NSInteger row = (moveToIndex%pageSize)/MOREVIEW_COL;
            NSInteger col = moveToIndex%MOREVIEW_COL;
            [moreButton setFrame:CGRectMake(page * CGRectGetWidth(self.frame) + insets * (col + 1) + CHAT_BUTTON_SIZE.width * col, INSETS + INSETS * 2 * row + CHAT_BUTTON_SIZE.height * row, CHAT_BUTTON_SIZE.width , CHAT_BUTTON_SIZE.height)];
            moreButton.tag = MOREVIEW_BUTTON_TAG+moveToIndex;
            [_scrollview setContentSize:CGSizeMake(CGRectGetWidth(self.frame) * (page + 1), CGRectGetHeight(self.frame))];
            [_pageControl setNumberOfPages:page + 1];
        }
    }
    _maxIndex--;
    if (_maxIndex >=5) {
        frame.size.height = 150;
    } else {
        frame.size.height = 80;
    }
    self.frame = frame;
    _scrollview.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    _pageControl.frame = CGRectMake(0, CGRectGetHeight(frame) - 20, CGRectGetWidth(frame), 20);
    _pageControl.hidden = _pageControl.numberOfPages<=1;
}

#pragma setter
//- (void)setMoreViewColumn:(NSInteger)moreViewColumn
//{
//    if (_moreViewColumn != moreViewColumn) {
//        _moreViewColumn = moreViewColumn;
//        [self setupSubviewsForType:_type];
//    }
//}
//
//- (void)setMoreViewNumber:(NSInteger)moreViewNumber
//{
//    if (_moreViewNumber != moreViewNumber) {
//        _moreViewNumber = moreViewNumber;
//        [self setupSubviewsForType:_type];
//    }
//}

- (void)setMoreViewBackgroundColor:(UIColor *)moreViewBackgroundColor
{
    _moreViewBackgroundColor = moreViewBackgroundColor;
    if (_moreViewBackgroundColor) {
        [self setBackgroundColor:_moreViewBackgroundColor];
    }
}

/*
- (void)setMoreViewButtonImages:(NSArray *)moreViewButtonImages
{
    _moreViewButtonImages = moreViewButtonImages;
    if ([_moreViewButtonImages count] > 0) {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                if (button.tag < [_moreViewButtonImages count]) {
                    NSString *imageName = [_moreViewButtonImages objectAtIndex:button.tag];
                    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
                }
            }
        }
    }
}

- (void)setMoreViewButtonHignlightImages:(NSArray *)moreViewButtonHignlightImages
{
    _moreViewButtonHignlightImages = moreViewButtonHignlightImages;
    if ([_moreViewButtonHignlightImages count] > 0) {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                if (button.tag < [_moreViewButtonHignlightImages count]) {
                    NSString *imageName = [_moreViewButtonHignlightImages objectAtIndex:button.tag];
                    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
                }
            }
        }
    }
}*/

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset =  scrollView.contentOffset;
    if (offset.x == 0) {
        _pageControl.currentPage = 0;
    } else {
        int page = offset.x / CGRectGetWidth(scrollView.frame);
        _pageControl.currentPage = page;
    }
}

#pragma mark - action

- (void)commonlanguageCallButtonAction{
    if(_delegate && [_delegate respondsToSelector:@selector(moreCommonlanguageCallButtonAction:)]){
        [_delegate moreCommonlanguageCallButtonAction:self];
    }
}

- (void)photoCallButtonAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(morePhotoCallButtonAction:)]) {
        [_delegate morePhotoCallButtonAction:self];
    }
}

- (void)issueadviceCallButtonAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreIssueadviceCallButtonAction:)]) {
        [_delegate moreIssueadviceCallButtonAction:self];
    }
}

- (void)articlerecommendCallButtonAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreArticlerecommendCallButtonAction:)]) {
        [_delegate moreArticlerecommendCallButtonAction:self];
    }
}

- (void)questionnaireCallButtonAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreQuestionnaireCallButtonAction:)]) {
        [_delegate moreQuestionnaireCallButtonAction:self];
    }
}

@end
