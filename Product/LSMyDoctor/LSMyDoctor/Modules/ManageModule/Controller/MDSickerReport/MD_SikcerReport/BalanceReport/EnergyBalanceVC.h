//
//  EnergyBalanceVC.h
//  YouGeHealth
//
//  Created by yunzujia on 16/11/10.
//
//

#import <UIKit/UIKit.h>
#import "BalanceModel.h"
@interface EnergyBalanceVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, strong) NSDate * currentDate;
@property (nonatomic,copy) NSString *cycle;//报告周期类型:daily weekly monthly yearly detail 五项
@property (nonatomic,assign) NSInteger date;//日期：YYYYmmdd
@property (nonatomic,copy) NSString *module;
@property (nonatomic, strong) NSDate * foodDate;
@property (nonatomic, strong) NSMutableArray <BalanceGroups *>* dataArray;
@end
