//
//  WuMessage.m
//  MPKX
//
//  Created by zzwu on 15/12/8.
//  Copyright © 2015年 zzwu. All rights reserved.
//

#import "WuMessage.h"

@implementation WuMessage

+ (instancetype)messageWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
