//
//  MDGroupCommunicateVC.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/20.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDGroupCommunicateVC.h"
#import "MDGroupDiscussDetailVC.h"
#import "MDSickerGroupDetialVC.h"

#import "LSRecommendArticleController.h"
#import "LSWorkArticleDetailController.h"

#import "LSRecommendArticleMessageCell.h"

@interface MDGroupCommunicateVC () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,EaseChatBarMoreViewDelegate,EaseMessageViewControllerDelegate,EaseMessageViewControllerDataSource>

@end

@implementation MDGroupCommunicateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;
    
    if (self.groupIdStr.length > 0) {
        UIButton* groupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        groupBtn.frame = CGRectMake(LSSCREENWIDTH - 100, 7, 80, 30);
        [groupBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [groupBtn setImage:[UIImage imageNamed:@"people_white"] forState:UIControlStateNormal];
        [groupBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 0)];
        UIBarButtonItem *copyBarBtn = [[UIBarButtonItem alloc] initWithCustomView:groupBtn];
        self.navigationItem.rightBarButtonItem = copyBarBtn;
        
    }
    
    // Do any additional setup after loading the view.
}

- (void)rightBtnClick
{
    if (self.isPeer) {
        MDGroupDiscussDetailVC* detailVC = [[MDGroupDiscussDetailVC alloc] init];
        detailVC.groupIdStr = self.groupIdStr;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        MDSickerGroupDetialVC* detailVC = [[MDSickerGroupDetialVC alloc] init];
        detailVC.groupIdStr = self.groupIdStr;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}

#pragma mark -- 自定义Cell
- (UITableViewCell*)messageViewController:(UITableView *)tableView cellForMessageModel:(id<IMessageModel>)messageModel
{
    NSDictionary *dic = messageModel.message.ext;
    NSLog(@"===%@===", dic);
    if (messageModel.message.ext) {
        if(messageModel.message.ext[@"recommendArticle"]){
            //文章推荐
            NSString* cellId = [LSRecommendArticleMessageCell cellIdentifierWithModel:messageModel];
            LSRecommendArticleMessageCell* cell = (LSRecommendArticleMessageCell*)[tableView dequeueReusableCellWithIdentifier:cellId];
            
            if (!cell) {
                cell = [[LSRecommendArticleMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId model:messageModel];
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
        if(messageModel.message.ext[@"recommendArticle"]){
            //文章推荐
            return 110.0f;
        }
        
    }
    return 0.f;
}


- (BOOL)messageViewController:(EaseMessageViewController *)viewController didSelectMessageModel:(id<IMessageModel>)messageModel
{
    BOOL flag = NO;
    
    if (messageModel.message.ext[@"recommendArticle"])
    {
        flag = YES;
        
        LSWorkArticleDetailController *vc = [[LSWorkArticleDetailController alloc] initWithNibName:@"LSWorkArticleDetailController" bundle:nil];
        vc.dic = messageModel.message.ext;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    return flag;
}

- (void)moreArticlerecommendCallButtonAction:(EaseChatBarMoreView *)moreView
{
    // Hide the keyboard
    [self.chatToolbar endEditing:YES];
    
    LSRecommendArticleController *vc = [[LSRecommendArticleController alloc] initWithNibName:@"LSRecommendArticleController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
    vc.sureBlock = ^(NSDictionary *dataDic) {
        [self sendTextMessage:@"[文章推荐]" withExt:dataDic];
    };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_CALL object:@{@"chatter":self.conversation.conversationId, @"type":[NSNumber numberWithInt:0]}];
}

#pragma mark -- 选择图片
- (void)morePhotoCallButtonAction:(EaseChatBarMoreView *)moreView
{
    //图片
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"选照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //首先需要判断资源是否可用
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
            
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            pickerImage.delegate = self;
            //设置允许编辑
            pickerImage.allowsEditing = YES;
            
            [self presentViewController:pickerImage animated:YES completion:^{
            }];
        }
    }];
    
    
    
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"拍照片");
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;//设置类型为相机
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
            picker.delegate = self;//设置代理
            picker.allowsEditing = YES;//设置照片可编辑
            picker.sourceType = sourceType;
            //设置是否显示相机控制按钮 默认为YES
            picker.showsCameraControls = YES;
            
            [self presentViewController:picker animated:YES completion:^{
            }];
        }
        else {
            [AlertHelper InitMyAlertMessage:@"您的设备不支持相机" And:self];
        }
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
    
    [alert addAction:action];
    [alert addAction:action1];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - 从相册选择图片后操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //获取裁剪后的图像
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    
    //如果是拍照，将照片存到媒体库
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
    
    
    
    [self.chatToolbar endEditing:YES];
    //发送图片
    [self sendImageMessage:image];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - 照片存到本地后的回调
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (!error) {
        NSLog(@"存储成功");
    } else {
        NSLog(@"存储失败：%@", error);
    }
}


@end
