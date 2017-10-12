//
//  LSUtil.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/25.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSUtil.h"
#import "LSPatientModel.h"

@implementation LSUtil

+(void)showAlter:(UIView *)view withText:(NSString *)text withOffset:(float)offset{
    if(view == nil){
        return;
    }
//    BlocMBProgressHUD *HUD = [BlocMBProgressHUD showHUDAddedTo:view animated:YES];
    BlocMBProgressHUD *HUD = [BlocMBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.color = nil;
    HUD.mode = MBProgressHUDModeText;
    HUD.detailsLabelText = text;
    HUD.margin = 10.f;
    HUD.yOffset = offset;
    HUD.removeFromSuperViewOnHide = YES;
    [HUD hide:YES afterDelay:2];
}

#pragma mark - 获取按A~Z顺序排列的所有联系人
+ (void)getOrderPatientList:(NSArray *)patientList patientListDictBlock:(PatientListDictBlock)patientListInfo 
{
    
    // 将耗时操作放到子线程
    dispatch_queue_t queue = dispatch_queue_create("addressBook.infoDict", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        
        NSMutableDictionary *addressBookDict = [NSMutableDictionary dictionary];
        NSMutableDictionary *OKaddressBookDict = [NSMutableDictionary dictionary];
        
        
        for (LSPatientModel *model in patientList) {
            //            获取到姓名的大写首字母
            NSString *firstLetterString = [self getFirstLetterFromString:model.name];
            //            如果该字母对应的联系人模型不为空,则将此联系人模型添加到此数组中
            if (addressBookDict[firstLetterString])
            {
                
                [addressBookDict[firstLetterString] setValue:model.name forKey:model.name];
            }
            //没有出现过该首字母，则在字典中新增一组key-value
            else
            {
                //创建新发可变数组存储该首字母对应的联系人模型
                //A：{158：李四，122：张三}
                NSMutableDictionary * dicPerson = [[NSMutableDictionary alloc] init];
                
                [dicPerson setValue:model.name forKey:model.name];

                
                [addressBookDict setValue:dicPerson forKey:firstLetterString];
                
            }
        }
        
        // 将addressBookDict字典中的所有Key值进行排序: A~Z
        NSArray *nameKeys = [[addressBookDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
        
        //将A:{124：李四，34：白雪}转换成--》A:[{tel:124,name:李四},{tel:34,name:白雪}]
        for (int i = 0; i < nameKeys.count; i ++) {
            NSString * mainkey = nameKeys[i];
            NSDictionary *dataDic = [[NSDictionary alloc] init];
            dataDic = addressBookDict[mainkey];
            
            
            NSArray * dataKey =dataDic.allKeys;
            
            for (int j =0 ; j < dataKey.count; j++) {
                NSString *tell = dataKey[j];
                NSString *name = [dataDic objectForKey:tell];
                NSMutableDictionary *dicPer = [[NSMutableDictionary alloc] init];
                [dicPer setValue:name forKey:@"name"];
                
                if (OKaddressBookDict[mainkey]) {
                    
                    [OKaddressBookDict[mainkey] addObject:dicPer];
                    
                }else{
                    NSMutableArray *oKarrGroupNames = [[NSMutableArray alloc]init];
                    
                    [oKarrGroupNames addObject:dicPer];
                    
                    [OKaddressBookDict setValue:oKarrGroupNames forKey:mainkey];
                    
                }
                
            }
        }
        
        
        NSArray *okNameKeys = [[OKaddressBookDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
        
        // 将 "#" 排列在 A~Z 的后面
        if ([okNameKeys.firstObject isEqualToString:@"#"])
        {
            NSMutableArray *mutableNamekeys = [NSMutableArray arrayWithArray:okNameKeys];
            [mutableNamekeys insertObject:okNameKeys.firstObject atIndex:okNameKeys.count];
            [mutableNamekeys removeObjectAtIndex:0];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //                addressBookInfo ? addressBookInfo(addressBookDict,mutableNamekeys) : nil;
                patientListInfo ? patientListInfo(OKaddressBookDict,mutableNamekeys) : nil;
            });
            return;
        }
        
        // 将排序好的通讯录数据回调到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            //            addressBookInfo ? addressBookInfo(addressBookDict,nameKeys) : nil;
            patientListInfo ? patientListInfo(OKaddressBookDict,nameKeys) : nil;
        });
        
    });
    
}

#pragma mark - 获取联系人姓名首字母(传入汉字字符串, 返回大写拼音首字母)
+ (NSString *)getFirstLetterFromString:(NSString *)aString
{
    /**
     * **************************************** START ***************************************
     * 之前PPGetAddressBook对联系人排序时在中文转拼音这一部分非常耗时
     * 参考博主-庞海礁先生的一文:iOS开发中如何更快的实现汉字转拼音 http://www.olinone.com/?p=131
     * 使PPGetAddressBook对联系人排序的性能提升 3~6倍, 非常感谢!
     */
    NSMutableString *mutableString = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    NSString *pinyinString = [mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    /**
     *  *************************************** END ******************************************
     */
    
    // 将拼音首字母装换成大写
    NSString *strPinYin = [[self polyphoneStringHandle:aString pinyinString:pinyinString] uppercaseString];
    // 截取大写首字母
    NSString *firstString = [strPinYin substringToIndex:1];
    // 判断姓名首位是否为大写字母
    NSString * regexA = @"^[A-Z]$";
    NSPredicate *predA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexA];
    // 获取并返回首字母
    return [predA evaluateWithObject:firstString] ? firstString : @"#";
    
}

/**
 多音字处理
 */
+ (NSString *)polyphoneStringHandle:(NSString *)aString pinyinString:(NSString *)pinyinString
{
    if ([aString hasPrefix:@"长"]) { return @"chang";}
    if ([aString hasPrefix:@"沈"]) { return @"shen"; }
    if ([aString hasPrefix:@"厦"]) { return @"xia";  }
    if ([aString hasPrefix:@"地"]) { return @"di";   }
    if ([aString hasPrefix:@"重"]) { return @"chong";}
    if ([aString hasPrefix:@"单"]) { return @"shan";}
    return pinyinString;
}

@end
