//
//  MDSingleCommunicateVC.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/18.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDSingleCommunicateVC.h"
#import "MDPeerDetailVC.h"//医生详情界面
#import "MDComRequestCell.h"

@interface MDSingleCommunicateVC ()

@end

@implementation MDSingleCommunicateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.titleNameStr;
    
    self.conversation.ext = [NSDictionary dictionary];
    
    UIButton* singleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    singleBtn.frame = CGRectMake(LSSCREENWIDTH - 100, 7, 80, 30);
    [singleBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [singleBtn setImage:[UIImage imageNamed:@"person"] forState:UIControlStateNormal];
    [singleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 0)];
    UIBarButtonItem *copyBarBtn = [[UIBarButtonItem alloc] initWithCustomView:singleBtn];
    self.navigationItem.rightBarButtonItem = copyBarBtn;
    
    // Do any additional setup after loading the view from its nib.
}
- (void)rightBtnClick
{
    MDPeerDetailVC* detailVC = [[MDPeerDetailVC alloc] init];
    detailVC.doctorIdStr = self.singleIdStr;
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark -- 自定义Cell
- (UITableViewCell*)messageViewController:(UITableView *)tableView cellForMessageModel:(id<IMessageModel>)messageModel
{
    if (messageModel.message.ext) {
        id message = messageModel.message.ext[@"content"];
        if(message){
            
            NSString* cellId = [MDComRequestCell cellIdentifierWithModel:messageModel];
            MDComRequestCell* cell = (MDComRequestCell*)[tableView dequeueReusableCellWithIdentifier:cellId];
            
            if (!cell) {
                cell = [[MDComRequestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId model:messageModel];
            }
            cell.model = messageModel;
            return cell;
        }
        
    }
    
    
    return nil;
    
}
//高度
- (CGFloat)messageViewController:(EaseMessageViewController *)viewController
           heightForMessageModel:(id<IMessageModel>)messageModel
                   withCellWidth:(CGFloat)cellWidth
{
    if (messageModel.message.ext) {
        id message = messageModel.message.ext[@"content"];
        if(message){
            return 120.0f;
        }
        
    }
    return 0.f;
}






@end
