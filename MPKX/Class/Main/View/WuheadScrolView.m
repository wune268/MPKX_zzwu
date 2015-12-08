//
//  WuheadScrolView.m
//  MPKX
//
//  Created by zzwu on 15/12/3.
//  Copyright © 2015年 zzwu. All rights reserved.
//

#import "WuheadScrolView.h"
#import "WuButton.h"
#import "MainBtn.h"

//#define Screen_Height [UIScreen mainScreen].bounds.size.height
#define Screen_Width [UIScreen mainScreen].bounds.size.width

@interface WuheadScrolView()

@property(nonatomic,weak)UIButton *genreSelectButton;
@property(nonatomic,strong)NSMutableArray *btnFaceArray;
@property(nonatomic,strong)NSMutableArray *btnEyeArray;
@property(nonatomic,strong)NSMutableArray *btnMouthArray;
@property(nonatomic,strong)NSMutableArray *btnEyebrowArray;
@property(nonatomic,strong)NSMutableArray *btnHeadEyeLashArray;
@property(nonatomic,weak)UIScrollView *headScrolView;
@property(nonatomic,assign)CGFloat headScrolViewH;

@end

@implementation WuheadScrolView

-(NSMutableArray *)btnEyebrowArray
{
    if (!_btnEyebrowArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"faceEyebrow.plist" ofType:nil];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *mArray = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            MainBtn *Mbtn = [MainBtn mainBtnWithDict:dict];
            [mArray addObject:Mbtn];
        }
        _btnEyebrowArray = mArray;
    }
    return _btnEyebrowArray;
}

-(NSMutableArray *)btnHeadEyeLashArray
{
    if (!_btnHeadEyeLashArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"faceHeadEyeLash.plist" ofType:nil];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *mArray = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            MainBtn *Mbtn = [MainBtn mainBtnWithDict:dict];
            [mArray addObject:Mbtn];
        }
        _btnHeadEyeLashArray = mArray;
    }
    return _btnHeadEyeLashArray;
}

-(NSMutableArray *)btnMouthArray
{
    if (!_btnMouthArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"faceMouth.plist" ofType:nil];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *mArray = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            MainBtn *Mbtn = [MainBtn mainBtnWithDict:dict];
            [mArray addObject:Mbtn];
        }
        _btnMouthArray = mArray;
    }
    return _btnMouthArray;
}

-(NSMutableArray *)btnEyeArray
{
    if (!_btnEyeArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"faceEye.plist" ofType:nil];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *mArray = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            MainBtn *Mbtn = [MainBtn mainBtnWithDict:dict];
            [mArray addObject:Mbtn];
        }
        _btnEyeArray = mArray;
    }
    return _btnEyeArray;
}

-(NSMutableArray *)btnFaceArray
{
    if (!_btnFaceArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"faceFace.plist" ofType:nil];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *mArray = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            MainBtn *Mbtn = [MainBtn mainBtnWithDict:dict];
            [mArray addObject:Mbtn];
        }
        _btnFaceArray = mArray;
    }
    return _btnFaceArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    //    设置标签位置
        CGFloat genreViewX = 0;
        CGFloat genreViewY = 0;
        CGFloat genreViewW = frame.size.width;
        CGFloat genreViewH = 40;
        CGFloat headScrolViewX = 0;
        CGFloat headScrolViewY = genreViewH;
        CGFloat headScrolViewW = frame.size.width;
        CGFloat headScrolViewH = frame.size.height - genreViewH;
        self.headScrolViewH = headScrolViewH;
        
        UIView *genreView = [[UIView alloc]initWithFrame:CGRectMake(genreViewX, genreViewY, genreViewW, genreViewH)];
        genreView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"juxing"]];

        for (int i = 0; i < 5; i ++) {
            CGFloat padding = 20;
            CGFloat btnW = (frame.size.width - 20 * 6) / 5;
            CGFloat btnY = 5;
            CGFloat btnX = i * (btnW + padding) + padding;
            WuButton *Btn = [WuButton buttonWithImage:[UIImage imageNamed:@"wuguan"] highlightedImage:nil selectImage:[UIImage imageNamed:@"show"] frame:CGRectMake(btnX, btnY, btnW, genreViewH * 0.75)];
            Btn.tag = i;
            [Btn addTarget:self action:@selector(genreBtnClick:) forControlEvents:UIControlEventTouchDown];
            if (Btn.tag == 0) {
                [self genreBtnClick:Btn];
            }
            [genreView addSubview:Btn];
        }

        [self addSubview:genreView];

    //    设置滚动头像表情位置
        UIScrollView *headScrolView = [[UIScrollView alloc]initWithFrame:CGRectMake(headScrolViewX, headScrolViewY, headScrolViewW, headScrolViewH)];
        headScrolView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"headBg"]];
        headScrolView.showsHorizontalScrollIndicator = NO;
        headScrolView.showsVerticalScrollIndicator = NO;
        headScrolView.bounces = NO;
        self.headScrolView = headScrolView;

        [self addSubview:headScrolView];

    }
    return self;
}

// 切换头像选项
-(void)genreBtnClick:(UIButton *)button
{
    self.genreSelectButton.selected = NO;
    button.selected = YES;
    self.genreSelectButton = button;
    switch (button.tag) {
        case 0:
            [self creatBtnWithName:self.btnEyeArray group:1];
            break;
        case 1:
            [self creatBtnWithName:self.btnEyebrowArray group:2];
            break;
        case 2:
            [self creatBtnWithName:self.btnFaceArray group:3];
            break;
        case 3:
            [self creatBtnWithName:self.btnHeadEyeLashArray group:4];
            break;
        case 4:
            [self creatBtnWithName:self.btnMouthArray group:5];
            break;

        default:
            break;
    }
}

// 滚动头像
-(void)scrolBtnClick:(UIButton *)btn
{
    UIButton *button = btn;
    NSInteger group = button.tag / 100;
    NSInteger index = button.tag % 100;
//    NSLog(@"%ld,%ld",index,(long)group);
    MainBtn *imageName;
    switch (group) {
        case 1:
            imageName = self.btnEyeArray[index];
            break;
        case 2:
            imageName = self.btnEyebrowArray[index];
            break;
        case 3:
            imageName = self.btnFaceArray[index];
            break;
        case 4:
            imageName = self.btnHeadEyeLashArray[index];
            break;
        case 5:
            imageName = self.btnMouthArray[index];
            break;
            
        default:
            break;
    }
    NSString *groupN = [NSString stringWithFormat:@"%ld",(long)group];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:imageName.icon, @"image_Name", groupN, @"group_group", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changHeadImage" object:nil userInfo:dict];
}

-(void)creatBtnWithName:(NSArray *)array group:(NSInteger)group
{
    while (self.headScrolView.subviews.firstObject) {
        [self.headScrolView.subviews.firstObject removeFromSuperview];
    }
    for (int i = 0; i < array.count; i ++)
    {
        MainBtn *btnImage = array[i];
        CGFloat padding = 20;
        CGFloat btnW = (Screen_Width - 20 * 5) / 4;
        CGFloat btnY = (self.headScrolViewH - btnW) * 0.5;
        CGFloat btnX = i * (btnW + padding) + padding;
        WuButton *Btn = [WuButton buttonWithImage:[UIImage imageNamed:btnImage.icon] highlightedImage:nil selectImage:nil frame:CGRectMake(btnX, btnY, btnW, btnW)];
        Btn.tag = group * 100 + i;
        [Btn addTarget:self action:@selector(scrolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.headScrolView.contentSize = CGSizeMake((btnW + padding) * array.count, 0);
        [self.headScrolView addSubview:Btn];
    }
}

@end
