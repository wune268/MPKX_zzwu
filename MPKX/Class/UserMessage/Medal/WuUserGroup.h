//
//  WuUserGroup.h
//  MPKX
//
//  Created by zzwu on 15/11/21.
//  Copyright © 2015年 zzwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WuUserGroup : NSObject

/**
 *  头部标题
 */
@property (nonatomic, copy) NSString *header;

/**
 *  尾部标题
 */
@property (nonatomic, copy) NSString *footer;

/**
 *  存放着这组所有行的模型数据(这个数组中都是WuUserItems对象)
 */
@property (nonatomic, strong) NSArray *items;

@end
