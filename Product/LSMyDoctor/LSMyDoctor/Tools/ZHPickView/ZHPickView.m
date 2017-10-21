//
//  ZHPickView.m
//  ZHpickView
//
//  Created by liudianling on 14-11-18.
//  Copyright (c) 2014年 赵恒志. All rights reserved.
//
#define ZHToobarHeight 40
#import "ZHPickView.h"

@interface ZHPickView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,copy)NSString *plistName;
@property(nonatomic,strong)NSArray *plistArray;
@property(nonatomic,strong)NSArray *defaultArray;
@property(nonatomic,assign)BOOL isLevelArray;
@property(nonatomic,assign)BOOL isLevelString;
@property(nonatomic,assign)BOOL isLevelDic;
@property(nonatomic,strong)NSDictionary *levelTwoDic;
@property(nonatomic,strong)UIToolbar *toolbar;
@property(nonatomic,strong)UIPickerView *pickerView;
@property(nonatomic,strong)UIDatePicker *datePicker;
@property(nonatomic,assign)NSDate *defaulDate;
@property(nonatomic,assign)NSDate *selectDate;
@property(nonatomic,assign)NSDate *minDate;
@property(nonatomic,assign)BOOL isHaveNavControler;
@property(nonatomic,assign)NSInteger pickeviewHeight;
@property(nonatomic,copy)NSString *resultString;
@property(nonatomic,strong)NSMutableArray *componentArray;
@property(nonatomic,strong)NSMutableArray *dicKeyArray;
@property(nonatomic,copy)NSMutableArray *state;
@property(nonatomic,copy)NSMutableArray *city;
@property (nonatomic,strong) UIView *viewBg;
@end

@implementation ZHPickView

-(NSArray *)plistArray{
    if (_plistArray==nil) {
        _plistArray=[[NSArray alloc] init];
    }
    return _plistArray;
}

-(NSArray *)defaultArray{
    if (_defaultArray==nil) {
        _defaultArray=[[NSArray alloc] init];
    }
    return _defaultArray;
}

-(NSArray *)componentArray{

    if (_componentArray==nil) {
        _componentArray=[[NSMutableArray alloc] init];
    }
    return _componentArray;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpToolBar];
        
    }
    return self;
}


-(instancetype)initPickviewWithPlistName:(NSString *)plistName isHaveNavControler:(BOOL)isHaveNavControler{
    
    self=[super init];
    if (self) {
        _plistName=plistName;
        self.plistArray=[self getPlistArrayByplistName:plistName];
        [self setUpPickView];
        [self setFrameWith:isHaveNavControler];
        
    }
    return self;
}

-(instancetype)initPickviewWithArray:(NSArray *)array isHaveNavControler:(BOOL)isHaveNavControler{
    self=[super init];
    if (self) {
        self.plistArray=array;
        [self setArrayClass:array];
        [self setUpPickView];
        [self setFrameWith:isHaveNavControler];
    }
    return self;
}

-(instancetype)initPickviewWithArray:(NSArray *)array defaultArray:(NSArray *)defaultarray isHaveNavControler:(BOOL)isHaveNavControler{
    self=[super init];
    if (self) {
        self.plistArray=array;
        self.defaultArray=defaultarray;
        [self setArrayClass:array];
        [self setUpPickView];
        [self setFrameWith:isHaveNavControler];
    }
    return self;
}

-(instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode isHaveNavControler:(BOOL)isHaveNavControler{
    
    self=[super init];
    if (self) {
        _defaulDate=defaulDate;
        [self setUpDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode];
        [self setFrameWith:isHaveNavControler];
    }
    return self;
}
-(instancetype)initDatePickWithDate:(NSDate *)defaulDate selectDate:(NSDate *)selectDate datePickerMode:(UIDatePickerMode)datePickerMode isHaveNavControler:(BOOL)isHaveNavControler{
    
    self=[super init];
    if (self) {
        _defaulDate=defaulDate;
        _selectDate=selectDate;
        [self setUpDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode];
        [self setFrameWith:isHaveNavControler];
    }
    return self;
}

-(instancetype)initDatePickWithDefaultDate:(NSDate *)defaulDate selectDate:(NSDate *)selectDate minDate:(NSDate *)minDate datePickerMode:(UIDatePickerMode)datePickerMode isHaveNavControler:(BOOL)isHaveNavControler{
    
    self=[super init];
    if (self) {
        _minDate = minDate;
        _defaulDate=defaulDate;
        _selectDate=selectDate;
        [self setUpDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode];
        [self setFrameWith:isHaveNavControler];
    }
    return self;
}

-(NSArray *)getPlistArrayByplistName:(NSString *)plistName{
    
    NSString *path= [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSArray * array=[[NSArray alloc] initWithContentsOfFile:path];
    [self setArrayClass:array];
    return array;
}

-(void)setArrayClass:(NSArray *)array{
    _dicKeyArray=[[NSMutableArray alloc] init];
    for (id levelTwo in array) {
        
        if ([levelTwo isKindOfClass:[NSArray class]]) {
            _isLevelArray=YES;
            _isLevelString=NO;
            _isLevelDic=NO;
        }else if ([levelTwo isKindOfClass:[NSString class]]){
            _isLevelString=YES;
            _isLevelArray=NO;
            _isLevelDic=NO;
            
        }else if ([levelTwo isKindOfClass:[NSDictionary class]])
        {
            _isLevelDic=YES;
            _isLevelString=NO;
            _isLevelArray=NO;
            _levelTwoDic=levelTwo;
            [_dicKeyArray addObject:[_levelTwoDic allKeys] ];
        }
    }
}


-(void)setFrameWith:(BOOL)isHaveNavControler{
    CGFloat toolViewX = 0;
    CGFloat toolViewH = _pickeviewHeight+ZHToobarHeight;
    CGFloat toolViewY ;
    if (isHaveNavControler) {
        toolViewY= [UIScreen mainScreen].bounds.size.height-toolViewH-50;
    }else {
        toolViewY= [UIScreen mainScreen].bounds.size.height-toolViewH;
    }
    CGFloat toolViewW = [UIScreen mainScreen].bounds.size.width;
    self.frame = CGRectMake(toolViewX, toolViewY, toolViewW, toolViewH);
}


-(void)setUpPickView{
    
    UIPickerView *pickView=[[UIPickerView alloc] init];
    [pickView sizeToFit];
    pickView.backgroundColor=[UIColor whiteColor];
    _pickerView=pickView;
    pickView.delegate=self;
    pickView.dataSource=self;
    
    pickView.frame=CGRectMake(0, ZHToobarHeight, [[UIScreen mainScreen] bounds].size.width, 216);
    _pickeviewHeight=pickView.frame.size.height;
    pickView.backgroundColor=[UIColor whiteColor];
    
    
    [pickView selectRow:([(NSArray*)self.plistArray[0] count]-1)/2 inComponent:0 animated:YES];
    if (self.plistArray.count>1) {
        [pickView selectRow:([(NSArray*)self.plistArray[1] count]-1)/2 inComponent:1 animated:YES];
    }
    if (self.defaultArray.count==1) {
        NSInteger index=0;
        if ([self.defaultArray[0] isEqualToString:@""]) {
           
        }
        else
        {

         
            index = [self.plistArray[0] indexOfObject:self.defaultArray[0]];  //张进，这里是判断前面数组是否含有后面得到下标
          
            [pickView selectRow:index inComponent:0 animated:YES];
        }
    }else if (self.defaultArray.count==2) {
        NSInteger index=0;
        if (![self.defaultArray[0] isEqualToString:@""]) {
            
            @try {
                index=[self.plistArray[0] indexOfObject:self.defaultArray[0]];
                [pickView selectRow:index inComponent:0 animated:YES];
            }
            @catch (NSException *exception) {
                NSLog(@"ZHPicker异常：%@",exception);
            }

        }
        if (![self.defaultArray[1] isEqualToString:@""]) {
            
            @try {
                index=[self.plistArray[1] indexOfObject:self.defaultArray[1]];
                [pickView selectRow:index inComponent:1 animated:YES];
            }
            @catch (NSException *exception) {
                NSLog(@"ZHPicker异常：%@",exception);
            }
            
        }
    }else if(self.defaultArray.count > 0){
        
        for (int i = 0;i < self.defaultArray.count; ++i) {
            
            if (![self.defaultArray[i] isEqualToString:@""]) {
                
                @try {
                    NSInteger index=[self.plistArray[i] indexOfObject:self.defaultArray[i]];
                    [pickView selectRow:index inComponent:i animated:YES];
                }
                @catch (NSException *exception) {
                    NSLog(@"ZHPicker异常：%@",exception);
                }
                
            }
        }
    }
    
    [self addSubview:pickView];
}

-(void)setUpDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode{
    UIDatePicker *datePicker=[[UIDatePicker alloc] init];
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    datePicker.datePickerMode = datePickerMode;
    datePicker.backgroundColor=[UIColor whiteColor];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    if (_minDate) {
        datePicker.minimumDate = _minDate;
    }else{
        NSDate* minDate =[dateFormatter dateFromString:@"1900-01-01"];
        datePicker.minimumDate=minDate;
    }
//    datePicker.maximumDate=[NSDate date];
    
    if (_selectDate) {
        [datePicker setDate:_selectDate];
    }else if (_defaulDate) {
        [datePicker setDate:_defaulDate];
    }
    
    _datePicker=datePicker;
    datePicker.frame=CGRectMake(0, ZHToobarHeight, [[UIScreen mainScreen] bounds].size.width, 216);
    _pickeviewHeight=datePicker.frame.size.height;
    [self addSubview:datePicker];
}

-(void)setUpToolBar{
    _toolbar=[self setToolbarStyle];
    [self setToolbarWithPickViewFrame];
    
    [self addSubview:_toolbar];
}
-(UIToolbar *)setToolbarStyle{
    UIToolbar *toolbar=[[UIToolbar alloc] init];
    
    UIBarButtonItem *lefttem=[[UIBarButtonItem alloc] initWithTitle:@" 取消 " style:UIBarButtonItemStylePlain target:self action:@selector(remove)];
    lefttem.tintColor=[UIColor blackColor];
    
    UIBarButtonItem *centerSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithTitle:@" 确定 " style:UIBarButtonItemStylePlain target:self action:@selector(doneClick)];
    right.tintColor=[UIColor blackColor];
    
    toolbar.items=@[lefttem,centerSpace,right];
    return toolbar;
}
-(void)setToolbarWithPickViewFrame{
    _toolbar.frame=CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, ZHToobarHeight);
}

#pragma mark piackView 数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    NSInteger component;
    if (_isLevelArray) {
        component=_plistArray.count;
    } else if (_isLevelString){
        component=1;
    }else if(_isLevelDic){
        component=[_levelTwoDic allKeys].count*2;
    }
    return component;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *rowArray=[[NSArray alloc] init];
    if (_isLevelArray) {
        rowArray=_plistArray[component];
    }else if (_isLevelString){
        rowArray=_plistArray;
    }else if (_isLevelDic){
        NSInteger pIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *dic=_plistArray[pIndex];
        for (id dicValue in [dic allValues]) {
                if ([dicValue isKindOfClass:[NSArray class]]) {
                    if (component%2==1) {
                        rowArray=dicValue;
                    }else{
                        rowArray=_plistArray;
                    }
            }
        }
    }
    return rowArray.count;
}

#pragma mark UIPickerViewdelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *rowTitle=nil;
    if (_isLevelArray) {
        rowTitle=_plistArray[component][row];
    }else if (_isLevelString){
        rowTitle=_plistArray[row];
    }else if (_isLevelDic){
        NSInteger pIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *dic=_plistArray[pIndex];
        if(component%2==0)
        {
            rowTitle=_dicKeyArray[row][component];
        }
        for (id aa in [dic allValues]) {
           if ([aa isKindOfClass:[NSArray class]]&&component%2==1){
                NSArray *bb=aa;
                if (bb.count>row) {
                    rowTitle=aa[row];
                }
            }
        }
    }
    return rowTitle;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (_isLevelDic&&component%2==0) {
        
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
    if (_isLevelString) {
        _resultString=_plistArray[row];
        
    }else if (_isLevelArray){
        _resultString=@"";
        if (![self.componentArray containsObject:@(component)]) {
            [self.componentArray addObject:@(component)];
        }
        for (int i=0; i<_plistArray.count;i++) {
            if ([self.componentArray containsObject:@(i)]) {
                NSInteger cIndex = [pickerView selectedRowInComponent:i];
                _resultString=[NSString stringWithFormat:@"%@-%@",_resultString,_plistArray[i][cIndex]];
            }else{
                
                if (_plistArray.count == 3) {
                    
                    NSInteger count=[self.plistArray[i] indexOfObject:self.defaultArray[i]];
                    _resultString=[NSString stringWithFormat:@"%@-%@",_resultString,_plistArray[i][count]];
                }
                
            }
            NSLog(@"%@",_resultString);
        }
        if (_plistArray.count == 3) {
            
        }else{
            if (![self.componentArray containsObject:@(0)]) {
                NSInteger index=([(NSArray*)self.plistArray[0] count]-1)/2;
                
                
                if (self.defaultArray && self.defaultArray.count > 0 && ![self.defaultArray[0] isEqualToString:@""]) {
                    index=[self.plistArray[0] indexOfObject:self.defaultArray[0]];
                }
                
                _resultString=[NSString stringWithFormat:@"-%@%@",_plistArray[0][index],_resultString];
            }
            
            if (![self.componentArray containsObject:@(1)]) {
                if (self.plistArray.count>1) {
                    NSInteger index=([(NSArray*)self.plistArray[1] count]-1)/2;
                    
                    if (self.defaultArray && self.defaultArray.count > 0 && ![self.defaultArray[1] isEqualToString:@""]) {
                        index=[self.plistArray[1] indexOfObject:self.defaultArray[1]];
                    }
                    
                    _resultString=[NSString stringWithFormat:@"%@-%@",_resultString,_plistArray[1][index]];
                }
            }
        }
    }else if (_isLevelDic){
        if (component==0) {
          _state =_dicKeyArray[row][0];
        }else{
            NSInteger cIndex = [pickerView selectedRowInComponent:0];
            NSDictionary *dicValueDic=_plistArray[cIndex];
            NSArray *dicValueArray=[dicValueDic allValues][0];
            if (dicValueArray.count>row) {
                _city =dicValueArray[row];
            }
        }
    }
}

-(void)remove{
    [_viewBg removeFromSuperview];
    [self removeFromSuperview];
}
-(void)show{
    _viewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LSSCREENWIDTH, LSSCREENHEIGHT)];
    _viewBg.backgroundColor = [UIColor blackColor];
    _viewBg.alpha = 0.3;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView:)];
    [_viewBg addGestureRecognizer:gesture];
    [[UIApplication sharedApplication].keyWindow addSubview:_viewBg];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
}
- (void)removeView:(UITapGestureRecognizer *)sender {
    [_viewBg removeFromSuperview];
    [self removeFromSuperview];
}
-(void)doneClick
{
    
    [_viewBg removeFromSuperview];
    if (_pickerView) {
        
        if (_resultString) {
           
        }else{
            if (_isLevelString) {
                _resultString=[NSString stringWithFormat:@"%@",_plistArray[0]];
            }else if (_isLevelArray){
                _resultString=@"";
                for (int i=0; i<_plistArray.count;i++) {
                    NSInteger count=0;
                    if (self.defaultArray.count==1&&![self.defaultArray[0] isEqualToString:@""]) {
                        count=[self.plistArray[0] indexOfObject:self.defaultArray[0]];
                        _resultString=[NSString stringWithFormat:@"%@-%@",_resultString,_plistArray[i][count]];
                    }else if (self.defaultArray.count==2&&![self.defaultArray[0] isEqualToString:@""]) {
                        
                        @try {
                            count=[self.plistArray[i] indexOfObject:self.defaultArray[i]];
                            _resultString=[NSString stringWithFormat:@"%@-%@",_resultString,_plistArray[i][count]];
                        }
                        @catch (NSException *exception) {
                            NSLog(@"ZHPicker异常：%@",exception);
                        }
                        
                    }else if (self.defaultArray.count==2&&![self.defaultArray[1] isEqualToString:@""]) {
                        count=[self.plistArray[i] indexOfObject:self.defaultArray[i]];
                        _resultString=[NSString stringWithFormat:@"%@-%@",_resultString,_plistArray[i][count]];
                    }else{
                        if (([(NSArray*)_plistArray[i] count])%2) {
                            count=([(NSArray*)_plistArray[i] count])/2;
                        }else{
                            count=([(NSArray*)_plistArray[i] count]-1)/2;
                        }
                        _resultString=[NSString stringWithFormat:@"%@-%@",_resultString,_plistArray[i][count]];
                    }
                }
            }else if (_isLevelDic){
                if (_state==nil) {
                     _state =_dicKeyArray[0][0];
                    NSDictionary *dicValueDic=_plistArray[0];
                    _city=[dicValueDic allValues][0][0];
                }
                if (_city==nil){
                    NSInteger cIndex = [_pickerView selectedRowInComponent:0];
                    NSDictionary *dicValueDic=_plistArray[cIndex];
                    _city=[dicValueDic allValues][0][0];
                    
                }
              _resultString=[NSString stringWithFormat:@"%@-%@",_state,_city];
           }
        }
    }else if (_datePicker) {
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
//        dateComponents.day = +1;
        NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:_datePicker.date options:0];
        _resultString=[NSString stringWithFormat:@"%@",newDate];
    }
    if ([self.delegate respondsToSelector:@selector(toobarDonBtnHaveClick:resultString:)]) {
        if (_pickerView) {
            if (_resultString.length>0) {
                _resultString=[_resultString substringFromIndex:1];
            }
        }
        [self.delegate toobarDonBtnHaveClick:self resultString:_resultString];
    }
    [self removeFromSuperview];
}


/**
 *  设置PickView的颜色
 */
-(void)setPickViewColer:(UIColor *)color{
    _pickerView.backgroundColor=color;
}
/**
 *  设置toobar的文字颜色
 */
-(void)setTintColor:(UIColor *)color{
    
    _toolbar.tintColor=color;
}
/**
 *  设置toobar的背景颜色
 */
-(void)setToolbarTintColor:(UIColor *)color{
    
    _toolbar.barTintColor=color;
}
-(void)dealloc{
    
    //NSLog(@"销毁了");
}
@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
