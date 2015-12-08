//
//  WuClipCircleView.m
//  MPKX
//
//  Created by zzwu on 15/11/22.
//  Copyright © 2015年 zzwu. All rights reserved.
//

#import "WuClipCircleView.h"

@interface WuClipCircleView()

/**
 *  圆的半径
 */
@property(nonatomic,assign)CGFloat cornerRadius;

@end

@implementation WuClipCircleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    self.cornerRadius = frame.size.width * 0.5;
    return self;
}

- (void)drawRect:(CGRect)rect {
    self.layer.borderWidth = self.borderWidth;
    self.layer.borderColor = self.borderColor.CGColor;
    self.layer.cornerRadius = self.cornerRadius;
    self.layer.masksToBounds = YES;
}


@end
