//
//  LSWorkUsefulAddController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/10/14.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkUsefulAddController.h"

@interface LSWorkUsefulAddController ()

@property (weak, nonatomic) IBOutlet YYPlaceholderTextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;


@end

@implementation LSWorkUsefulAddController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initForView];
}

- (void)initForView
{
    self.navigationItem.title = @"编辑常用语";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.textView.text = self.text;
    self.textView.placeholder = @"请输入常用语";
    
    if (!self.text)
    {
        self.deleteBtn.hidden = YES;
    }
}

- (void)rightItemClick
{
    NSString *temp = [self.textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (temp.length<=0)
    {
        [XHToast showCenterWithText:@"请输入常用语"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    if (self.text)
    {
        //修改
        NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
        
        [param setValue:[Defaults valueForKey:@"cookie"] forKey:@"cookie"];
        [param setValue:[Defaults valueForKey:@"accessToken"] forKey:@"accessToken"];
        [param setValue:self.textView.text forKey:@"content"];
        [param setValue:@"" forKey:@"id"];
        
        NSString *url = PATH(@"%@/updateChatCommon");
        
        [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
            NSLog(@"%@", responseObj);
        } failBlock:^(NSError *error) {
            NSLog(@"");
        }];
    }
    else
    {
        //添加
        NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
        
        [param setValue:[Defaults valueForKey:@"cookie"] forKey:@"cookie"];
        [param setValue:[Defaults valueForKey:@"accessToken"] forKey:@"accessToken"];
        [param setValue:self.textView.text forKey:@"content"];
        
        NSString *url = PATH(@"%@/addChatCommon");
        
        [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
            NSLog(@"%@", responseObj);
        } failBlock:^(NSError *error) {
            NSLog(@"");
        }];
    }
    
    
}

- (IBAction)deleteBtnClick:(UIButton *)btn
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:[Defaults valueForKey:@"cookie"] forKey:@"cookie"];
    [param setValue:[Defaults valueForKey:@"accessToken"] forKey:@"accessToken"];
    [param setValue:@"" forKey:@"id"];
    
    NSString *url = PATH(@"%@/deleteChatCommon");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        NSLog(@"%@", responseObj);
    } failBlock:^(NSError *error) {
        NSLog(@"");
    }];
}

@end
