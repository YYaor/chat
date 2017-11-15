
//
//  LSWorkScanController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/11/13.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkScanController.h"

@interface LSWorkScanController ()

@end

@implementation LSWorkScanController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    UIImageView *imageView = [[UIImageView alloc]init];
    [self.view addSubview:imageView];
    
    UITextView *contentTextView = [[UITextView alloc]init];
    [self.view addSubview:contentTextView];

    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo([UIApplication sharedApplication].keyWindow.bounds.size.width-40);
    }];
    contentTextView.text = self.content;
    if (self.imageURL) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", UGAPI_HOST, self.imageURL]]];
        [contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20);
            make.top.equalTo(imageView.mas_bottom).offset(20);
            make.right.equalTo(self.view).offset(-20);
            make.height.mas_equalTo(300);
        }];
    }else{
        imageView.hidden = YES;
        
        [contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20);
            make.top.equalTo(self.view).offset(20);
            make.right.equalTo(self.view).offset(-20);
            make.height.mas_equalTo(300);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
