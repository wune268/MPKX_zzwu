//
//  WUUserArrowItem.m
//  MPKX
//
//  Created by zzwu on 15/11/21.
//  Copyright © 2015年 zzwu. All rights reserved.
//

#import "WuUserArrowItem.h"

@implementation WuUserArrowItem

+(instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVclass:(__unsafe_unretained Class)destVclass
{    
    WuUserArrowItem *item = [self itemWithIcon:icon title:title];
    item.destVclass = destVclass;
    return item;
}

@end
