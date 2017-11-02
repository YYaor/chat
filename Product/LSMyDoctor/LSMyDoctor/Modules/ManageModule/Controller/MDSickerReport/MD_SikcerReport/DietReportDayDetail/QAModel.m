//
//  QAModel.m
//  YouGeHealth
//
//  Created by yunzujia on 16/11/11.
//
//

#import "QAModel.h"

@implementation QAModel
-(NSMutableArray<NSString *> *)anser{
    if (!_anser) {
        _anser = [[NSMutableArray alloc] init];
    }
    return _anser;
}

@end
