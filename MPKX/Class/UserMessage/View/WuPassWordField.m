//
//  WuPassWordField.m
//  MPKX
//
//  Created by zzwu on 15/11/25.
//  Copyright © 2015年 zzwu. All rights reserved.
//

#import "WuPassWordField.h"

@implementation WuPassWordField

- (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[WuPassWordField alloc] initWithFrame:frame];
        self.placeholder = placeholder;
        self.secureTextEntry = YES;
        self.borderStyle = UITextBorderStyleRoundedRect;
        self.returnKeyType = UIReturnKeyNext;
        self.enablesReturnKeyAutomatically = YES;
    }
    return self;
}

+ (instancetype)passWordWithFrame:(CGRect)frame placeholder:(NSString *)placeholder
{
    return [[self alloc] initWithFrame:frame placeholder:placeholder];
}

@end
