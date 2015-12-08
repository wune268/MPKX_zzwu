//
//  WuHeadView.m
//  MPKX
//
//  Created by zzwu on 15/11/22.
//  Copyright © 2015年 zzwu. All rights reserved.
//

#import "WuHeadView.h"
#import "WuImageView.h"

@interface WuHeadView()

/**
 *  头像
 */
@property(nonatomic, weak)WuImageView *headView0;
@property(nonatomic, weak)WuImageView *headView1;

/**
 *  脸
 */
@property(nonatomic, weak)WuImageView *headFaceView;

/**
 *  眼睛
 */
@property(nonatomic, weak)WuImageView *headEyeView;

/**
 *  眉毛
 */
@property(nonatomic, weak)WuImageView *headEyeBrowView;

/**
 *  睫毛
 */
@property(nonatomic, weak)WuImageView *headEyeLashView;

/**
 *  眼睛
 */
@property(nonatomic, weak)WuImageView *headGlassesView;

/**
 *  嘴巴
 */
@property(nonatomic, weak)WuImageView *headMouseView;

@end

@implementation WuHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //    头像
        CGFloat headViewH = frame.size.height * 0.8;
        CGFloat headViewW = headViewH * 1.07;
        CGFloat headViewX = (frame.size.width - headViewW) * 0.5;
        CGFloat headViewY = frame.size.height * 0.1;
        
        //    脸
        CGFloat headFaceViewY = headViewH * 0.3;
        CGFloat headFaceViewW = headViewW * 0.7;
        CGFloat headFaceViewH = headViewH * 0.7;
        CGFloat headFaceViewX = (headViewW - headFaceViewW) * 0.5;
        
        //    眼睛
        CGFloat headEyeViewY = headFaceViewH * 0.26;
        CGFloat headEyeViewW = headFaceViewW * 0.70;
        CGFloat headEyeViewH = 35;
        CGFloat headEyeViewX = (headFaceViewW - headEyeViewW) * 0.5;
        
        //    睫毛
        CGFloat headEyeLashViewY = headFaceViewH * 0.19;
        CGFloat headEyeLashViewW = headFaceViewW * 0.8;
        CGFloat headEyeLashViewH = 20;
        CGFloat headEyeLashViewX = (headFaceViewW - headEyeLashViewW) * 0.5;
        
        //    眉毛
        CGFloat headEyeBrowViewY = headFaceViewH * 0.14;
        CGFloat headEyeBrowViewW = headFaceViewW * 0.73;
        CGFloat headEyeBrowViewH = 10;
        CGFloat headEyeBrowViewX = (headFaceViewW - headEyeBrowViewW) * 0.5;
        
        //    眼镜
        CGFloat headGlassesViewY = headFaceViewH * 0.21;
        CGFloat headGlassesViewW = headFaceViewW * 0.85;
        CGFloat headGlassesViewH = 44;
        CGFloat headGlassesViewX = (headFaceViewW - headGlassesViewW) * 0.5;
        
        //    嘴巴
        CGFloat headMouseViewY = headFaceViewH * 0.65;
        CGFloat headMouseViewW = headFaceViewW * 0.2;
        CGFloat headMouseViewH = 7;
        CGFloat headMouseViewX = (headFaceViewW - headMouseViewW) * 0.5;
        
        //    设置头像位置
        WuImageView *headView0 = [WuImageView imageViewWithNomalImage:[UIImage imageNamed:@"head1"] frame:CGRectMake(headViewX, headViewY, headViewW, headViewH)];
        self.headView0 = headView0;
//        WuImageView *headView2 = [WuImageView imageViewWithNomalImage:[UIImage imageNamed:@"HeadR"] frame:CGRectMake(headViewX, headViewY, headViewW, headViewH)];
//        self.headView = headView2;
//        headView0.alpha = 0.5;
//        headView0.alpha = 0.8;
//        headView0.alpha = 0.3;
        
        //    设置脸的位置
        WuImageView *headFaceView = [WuImageView imageViewWithNomalImage:[UIImage imageNamed:@"face"] frame:CGRectMake(headFaceViewX, headFaceViewY, headFaceViewW, headFaceViewH)];
        self.headFaceView = headFaceView;
        [headView0 addSubview:headFaceView];
        
        WuImageView *headView1 = [WuImageView imageViewWithNomalImage:[UIImage imageNamed:@"HeadY"] frame:CGRectMake(headViewX, headViewY, headViewW, headViewH)];
        self.headView1 = headView1;
        
        //    设置睫毛位置
        WuImageView *headEyeLashView = [WuImageView imageViewWithNomalImage:[UIImage imageNamed:@"eyephiz1"] frame:CGRectMake(headEyeLashViewX, headEyeLashViewY, headEyeLashViewW, headEyeLashViewH)];
        self.headEyeLashView = headEyeLashView;
        [headFaceView addSubview:headEyeLashView];
        
        //    设置眼睛的位置
        WuImageView *headEyeView = [WuImageView imageViewWithNomalImage:[UIImage imageNamed:@"brow0"] frame:CGRectMake(headEyeViewX, headEyeViewY, headEyeViewW, headEyeViewH)];
        self.headEyeView = headEyeView;
        [headFaceView addSubview:headEyeView];
        
        //    设置眉毛位置
        WuImageView *headEyeBrowView = [WuImageView imageViewWithNomalImage:[UIImage imageNamed:@"eyebrow1"] frame:CGRectMake(headEyeBrowViewX, headEyeBrowViewY, headEyeBrowViewW, headEyeBrowViewH)];
        self.headEyeBrowView = headEyeBrowView;
        [headFaceView addSubview:headEyeBrowView];
        
        //    设置眼镜位置
        WuImageView *headGlassesView = [WuImageView imageViewWithNomalImage:[UIImage imageNamed:@"glasses"] frame:CGRectMake(headGlassesViewX, headGlassesViewY, headGlassesViewW, headGlassesViewH)];
        self.headGlassesView = headGlassesView;
        [headFaceView addSubview:headGlassesView];
        
        //    设置嘴巴位置
        WuImageView *headMouseView = [WuImageView imageViewWithNomalImage:[UIImage imageNamed:@"mouth1"] frame:CGRectMake(headMouseViewX, headMouseViewY, headMouseViewW, headMouseViewH)];
        self.headMouseView = headMouseView;
        [headFaceView addSubview:headMouseView];
        
        [self addSubview:headView0];
        [self addSubview:headView1];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headScrolViewDidClick:) name:@"changHeadImage" object:nil];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+(WuHeadView *)headViewWithFrame:(CGRect)frame
{
    return [[self alloc] initWithFrame:frame];
}

-(void)headScrolViewDidClick:(NSNotification *)note
{
    NSString *imageName = [note.userInfo objectForKey:@"image_Name"];
    switch ([[note.userInfo objectForKey:@"group_group"] integerValue])
    {
        case 1:
            self.headEyeView.image = [UIImage imageNamed:imageName];
            break;
            
        case 2:
            self.headEyeBrowView.image = [UIImage imageNamed:imageName];
            break;
            
        case 3:
            self.headView0.image = [UIImage imageNamed:imageName];
            NSLog(@"%@",imageName);
            int b= [[imageName substringWithRange:NSMakeRange(4,1)] intValue];
            NSLog(@"%d",b);
            if (b > 3) {
//                self.headView1.hidden = NO;
                self.headView0.image = nil;
                self.headView1.image = [UIImage imageNamed:imageName];
//                self.headView0.hidden = YES;
            }
            else
            {
//                self.headView0.hidden = NO;
                self.headView1.image = nil;
                self.headView0.image = [UIImage imageNamed:imageName];
//                self.headView1.hidden = YES;
            }
            break;
        case 4:
            self.headEyeLashView.image = [UIImage imageNamed:imageName];
            break;
            
        case 5:
            self.headMouseView.image = [UIImage imageNamed:imageName];
            break;
            
        default:
            break;
    }
}

@end
