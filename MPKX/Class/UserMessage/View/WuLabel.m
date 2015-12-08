//
//  WuLabel.m
//  MPKX
//
//  Created by zzwu on 15/11/25.
//  Copyright © 2015年 zzwu. All rights reserved.
//

#import "WuLabel.h"

@implementation WuLabel

+(instancetype)labelWithFrame:(CGRect)frame text:(NSString *)text
{
    return [[self alloc] initWithFrame:frame text:text];
}

-(instancetype)initWithFrame:(CGRect)frame text:(NSString *)text
{
    self = [super initWithFrame:frame];
    if (self) {
        self  = [[WuLabel alloc] initWithFrame:frame];
        self.text = text;
        self.font = [UIFont systemFontOfSize:12];
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.0;
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
    }
    return self;
}

@end
