//
//  LSWorkUsefulAddController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/10/14.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkUsefulAddController.h"

@interface LSWorkUsefulAddController () <UITextViewDelegate>

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
    
    self.textView.placeholder = @"请输入常用语";
    
    self.textView.text = self.dataDic[@"content"];
    
    if (!self.dataDic[@"content"])
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
    
    if (self.dataDic[@"content"])
    {
        //修改
        NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
        
        [param setValue:self.textView.text forKey:@"content"];
        [param setValue:self.dataDic[@"id"] forKey:@"id"];
        
        NSString *url = PATH(@"%@/updateChatCommon");
        
        [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
            if ([responseObj[@"status"] integerValue] == 0) {
//                [weakSelf.dataDic removeObjectForKey:@"content"];
//                [weakSelf.dataDic setValue:weakSelf.textView.text forKey:@"content"];
                if (weakSelf.updateBlock) {
                    weakSelf.updateBlock(responseObj[@"data"]);
                }
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        } failBlock:^(NSError *error) {
            NSLog(@"");
        }];
    }
    else
    {
        //添加
        NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
        
        [param setValue:self.textView.text forKey:@"content"];
        
        NSString *url = PATH(@"%@/addChatCommon");
        
        [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
            NSLog(@"%@", responseObj);
            if ([responseObj[@"status"] integerValue] == 0) {
                weakSelf.dataDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.textView.text,@"content", nil];
                if (weakSelf.addBlock) {
                    weakSelf.addBlock(weakSelf.dataDic);
                }
                
                [XHToast showCenterWithText:responseObj[@"data"][@"message"]];
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            
        } failBlock:^(NSError *error) {
            NSLog(@"");
        }];
    }
    
    
}

- (IBAction)deleteBtnClick:(UIButton *)btn
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:self.dataDic[@"id"] forKey:@"id"];
    
    NSString *url = PATH(@"%@/deleteChatCommon");
    __weak typeof(self) weakSelf = self;
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj[@"status"] integerValue] == 0) {
            if (weakSelf.deleteBlock) {
                weakSelf.deleteBlock(weakSelf.dataDic);
            }
            
            [JKAlert alertText:responseObj[@"data"][@"message"]];
            
            [weakSelf.navigationController popViewControllerAnimated:YES];

        }
    } failBlock:^(NSError *error) {
        NSLog(@"");
    }];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 50)
    {
        textView.text = [textView.text substringToIndex:50];
    }
}

@end
