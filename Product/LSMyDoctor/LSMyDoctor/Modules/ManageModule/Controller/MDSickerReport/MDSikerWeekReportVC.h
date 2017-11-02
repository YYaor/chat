//
//  MDSikerWeekReportVC.h
//  MyDoctor
//
//  Created by 惠生 on 17/8/3.
//  Copyright © 2017年 惠生. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDSickerDetailModel.h"

@interface MDSikerWeekReportVC : UIViewController

@property (nonatomic ,strong)MDSickerDetailModel* sickerModel;
@property (nonatomic ,strong)NSMutableArray* sickerLabelsArr;

@end
