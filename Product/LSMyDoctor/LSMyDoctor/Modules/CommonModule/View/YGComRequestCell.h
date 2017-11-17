//
//  YGComRequestCell.h
//  YouGeHealth
//
//  Created by WangQuanjiang on 2017/11/8.
//
//

#import "EaseBaseMessageCell.h"

typedef void(^AgreeBlock)(NSString* status , NSString* requestId);//

@interface YGComRequestCell : EaseBaseMessageCell

@property (nonatomic , strong)AgreeBlock sureBlock;

@end
