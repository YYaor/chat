//
//  GuidePageModel.h
//  YouGeHealth
//
//  Created by earlyfly on 16/10/19.
//
//

#import <Foundation/Foundation.h>

@interface GuidePageModel : NSObject<YYModel>

@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *picture;

@property (nonatomic,copy) NSString *link;

@end
