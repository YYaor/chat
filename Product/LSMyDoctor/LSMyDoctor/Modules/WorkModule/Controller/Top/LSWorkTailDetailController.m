//
//  LSWorkTailDetailController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/28.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkTailDetailController.h"

#import "LSWorkTailDetailUserCell.h"
#import "LSWorkTailDetailCell.h"

static NSString *cellId1 = @"LSWorkTailDetailUserCell";
static NSString *cellId2 = @"LSWorkTailDetailCell";

@interface LSWorkTailDetailController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LSWorkTailDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initForView];
}

- (void)initForView
{
    self.navigationItem.title = @"医嘱详情";
    
    [self.tableView registerNib:[UINib nibWithNibName:cellId1 bundle:nil] forCellReuseIdentifier:cellId1];
    [self.tableView registerNib:[UINib nibWithNibName:cellId2 bundle:nil] forCellReuseIdentifier:cellId2];
    
    self.tableView.estimatedRowHeight = 10000;

}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        LSWorkTailDetailUserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId1 forIndexPath:indexPath];
        return cell;
    }
    else
    {
        LSWorkTailDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId2 forIndexPath:indexPath];
        return cell;
    }
}

@end
