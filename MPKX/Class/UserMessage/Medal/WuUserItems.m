//
//  WuUserItems.m
//  MPKX
//
//  Created by zzwu on 15/11/21.
//  Copyright © 2015年 zzwu. All rights reserved.
//

#import "WuUserItems.h"

@implementation WuUserItems

+(instancetype) itemWithIcon:(NSString *)icon title:(NSString *)title
{
    WuUserItems *item = [self itemWithTitle:title];
    item.icon = icon;
    return item;
}

+(instancetype) itemWithTitle:(NSString *)title
{
    WuUserItems *item = [[self alloc] init];
    item.title = title;
    return item;
}

@end
