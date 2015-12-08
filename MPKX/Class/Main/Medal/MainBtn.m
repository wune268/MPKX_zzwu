//
//  MainBtn.m
//  MPKX
//
//  Created by zzwu on 15/11/20.
//  Copyright © 2015年 zzwu. All rights reserved.
//

#import "MainBtn.h"

@implementation MainBtn

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+(instancetype)mainBtnWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}

@end
