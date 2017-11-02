//
//  DayDetailHeader.h
//  YouGeHealth
//
//  Created by yunzujia on 16/11/11.
//
//

#import <UIKit/UIKit.h>
#import "DietModel.h"

typedef void(^TasteBlock)(void);

@interface DayDetailHeader : UITableViewHeaderFooterView

@property (nonatomic, copy) TasteBlock tBlock;

@property (nonatomic, strong) SelectedfoodlistModel * model;
@end
