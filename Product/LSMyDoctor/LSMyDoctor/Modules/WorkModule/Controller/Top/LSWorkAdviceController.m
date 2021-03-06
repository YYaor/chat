//
//  LSWorkAdviceController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/28.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkAdviceController.h"

#import "LSWorkAdviceDetailController.h"

#import "LSWorkAdviceCell.h"

#import <Foundation/Foundation.h>
//#import "FMDBTool.h"
static NSString *cellId = @"LSWorkAdviceCell";

@interface LSWorkAdviceController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation LSWorkAdviceController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initForView];
    [self requestData];
}

- (void)initForView
{
    self.navigationItem.title = @"患者请求";
    
    [self.tableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
    
    self.tableView.rowHeight = 100;
}

- (void)requestData
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:@1 forKey:@"pagenum"];
    [param setValue:@100 forKey:@"pagesize"];
    [param setValue:@1 forKey:@"type"];

    NSString *url = PATH(@"%@/beRequestList");
    self.dataArray = [[NSMutableArray alloc]init];
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]])
        {
            NSDictionary * dict = responseObj;
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:dict[@"data"][@"content"]];
            [self.tableView reloadData];
            
            if (self.dataArray.count == 0)
            {
                [XHToast showCenterWithText:@"您没有待处理的患者请求"];
            }
        }
    } failBlock:^(NSError *error) {
        //[XHToast showCenterWithText:@"fail"];
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    LSWorkAdviceDetailController *vc = [[LSWorkAdviceDetailController alloc] initWithNibName:@"LSWorkAdviceDetailController" bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSWEAKSELF;
    
    LSWorkAdviceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.dataDic = self.dataArray[indexPath.row];
    
    cell.agreeClickBlock = ^(NSDictionary *dataDic) {
//        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:dataDic];
        [weakSelf requestData];
    };
    
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSWEAKSELF;
    
    NSDictionary *dataDic =self.dataArray[indexPath.row];
    UITableViewRowAction *action = nil;
    if ([dataDic[@"result"] isEqualToString:@"已通过"]) {
        action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath)
                  {
                      NSLog(@"___%s___", __func__);
                      NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
                      [param setValue:dataDic[@"id"] forKey:@"id"];
                      NSString *url = PATH(@"%@/removeRequest");
                      
                      [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
                          if ([responseObj[@"data"][@"status"] integerValue] == 0) {
//                              [self.dataArray removeObjectAtIndex:indexPath.row];
//                              [self.tableView reloadData];
                              [weakSelf requestData];
                              
                              [XHToast showCenterWithText:@"删除成功"];
                          }
                      } failBlock:^(NSError *error) {
                          //[XHToast showCenterWithText:@"fail"];
                      }];
                  }];
    }else{
        action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"拒绝" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath)
                  {
                      NSLog(@"___%s___", __func__);
                      NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
                      
                      [param setValue:dataDic[@"id"] forKey:@"id"];
                      [param setValue:@2 forKey:@"result"];
                      
                      NSString *url = PATH(@"%@/dealwithRequest");
                      
                      [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
                          if ([responseObj[@"data"][@"status"] integerValue] == 0) {
//                              [self.dataArray removeObjectAtIndex:indexPath.row];
//                              [self.tableView reloadData];
                              [weakSelf requestData];
                          }
                          
                      } failBlock:^(NSError *error) {
                          //[XHToast showCenterWithText:@"fail"];
                      }];
                  }];
    }
   
    
    return @[action];
}
@end
