//
//  WUUserArrowItem.h
//  MPKX
//
//  Created by zzwu on 15/11/21.
//  Copyright © 2015年 zzwu. All rights reserved.
//

#import "WuUserItems.h"

@interface WuUserArrowItem : WuUserItems

@property(nonatomic,assign) Class destVclass;

/**
 *  创建cell模型
 *
 *  @param icon       图片
 *  @param title      文字
 *  @param destVclass 跳转的控制器
 */
+(instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVclass:(Class)destVclass;

@end
