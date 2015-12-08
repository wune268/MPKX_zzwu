//
//  WuPassWordField.h
//  MPKX
//
//  Created by zzwu on 15/11/25.
//  Copyright © 2015年 zzwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WuPassWordField : UITextField

- (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder;
+ (instancetype)passWordWithFrame:(CGRect)frame placeholder:(NSString *)placeholder;

@end
