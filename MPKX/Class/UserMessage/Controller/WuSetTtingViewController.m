//
//  WuSetTtingViewController.m
//  MPKX
//
//  Created by zzwu on 15/11/21.
//  Copyright © 2015年 zzwu. All rights reserved.
//

#import "WuSetTtingViewController.h"
#import "WuUserGroup.h"
#import "WuUserArrowItem.h"
#import "WuUserSwitchItem.h"
#import "WuUserItems.h"

@interface WuSetTtingViewController ()

@end

@implementation WuSetTtingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupGroup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupGroup
{
    WuUserItems *pushMessage = [WuUserSwitchItem itemWithIcon:nil title:@"消息通知"];
    WuUserItems *update = [WuUserItems itemWithIcon:nil title:@"检查更新"];
    update.option = ^{
        // 弹框提示

#warning 发送网络请求
        // 几秒后消失
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
        });
    };
    WuUserItems *reSet = [WuUserItems itemWithIcon:nil title:@"还原设定"];
    
    WuUserGroup *group = [[WuUserGroup alloc] init];
    group.items = @[pushMessage, update, reSet];
    [self.data addObject:group];
}

@end
