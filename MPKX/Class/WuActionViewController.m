//
//  WuActionViewController.m
//  MPKX(zzWu-1025)
//
//  Created by zzwu on 15/10/25.
//  Copyright © 2015年 zzwu. All rights reserved.
//

#import "WuActionViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WuClipCircleView.h"

//  获取屏幕的宽度和高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface WuActionViewController ()<AVAudioPlayerDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong)NSArray *btnArray;

@end

@implementation WuActionViewController
{
    UIImageView *contView;
    UIImageView *centerView;
    UIImageView *centerView1;
    CGFloat circleR;
    CGFloat viewH;
    SystemSoundID shortSound;
    AVAudioPlayer *audioPlayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    创建界面按钮视图
    [self creatView];
    
//    设置标题栏两边按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(Share:)];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(SettingBtn:)];
    
//    设置背景色
    [self.view setBackgroundColor:[UIColor colorWithRed:231.0/225.0 green:179.0/225.0 blue:163.0/225.0 alpha:1]];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    停止播放
    [audioPlayer stop];
}

-(void)creatView
{
    viewH = 172;
    circleR = 230;
    
    CGFloat centerViewH = SCREEN_WIDTH * 1.3;
    CGFloat centerViewW = SCREEN_WIDTH;
    CGFloat centerViewX = 0;
    CGFloat centerViewY = 64;
    
    CGFloat centerView1H = centerViewH;
    CGFloat centerView1W = centerViewW;
    CGFloat centerView1X = 0;
    CGFloat centerView1Y = 0;
    
    CGFloat contViewH = circleR;
    CGFloat contViewW = circleR;
    CGFloat contViewX = (SCREEN_WIDTH - circleR) / 2;
    CGFloat contViewY = centerViewH - contViewH;
    
//    创建中心视图
    centerView = [[UIImageView alloc]initWithFrame:CGRectMake(centerViewX, centerViewY, centerViewW, centerViewH)];
    [self.view addSubview:centerView];
    
    WuClipCircleView *CV= [[WuClipCircleView alloc]initWithFrame:CGRectMake(contViewX, contViewY, contViewW, contViewH)];
    CV.backgroundColor = [UIColor clearColor];
    
    UIScrollView *contScrollView = [[UIScrollView alloc]initWithFrame:CV.bounds];
    contView = [[UIImageView alloc]initWithFrame:contScrollView.bounds];
//    添加点击事件打开相机
    contView.userInteractionEnabled = YES;
    UITapGestureRecognizer *imageClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openCameraOrPhoto:)];
    [contView addGestureRecognizer:imageClick];
    
    contScrollView.delegate = self;
    contScrollView.maximumZoomScale = 2.0;
    contScrollView.minimumZoomScale = 0.5;
    contScrollView.contentSize = CGSizeMake(circleR, circleR);
    contScrollView.showsVerticalScrollIndicator = NO;
    contScrollView.showsHorizontalScrollIndicator = NO;
    contScrollView.bounces = NO;
    
    [contScrollView addSubview:contView];
    
    [CV addSubview:contScrollView];
    centerView.userInteractionEnabled = YES;
    [centerView addSubview:CV];
    
    centerView1 = [[UIImageView alloc]initWithFrame:CGRectMake(centerView1X, centerView1Y, centerView1W,centerView1H)];
    centerView1.image = [UIImage imageNamed:@"刷牙动画0001"];
    [centerView addSubview:centerView1];
    
    [self creatButtonWithName:@"刷牙图标88_88" andTime:0];
    [self creatButtonWithName:@"变形头盔图标88_88" andTime:1];
    [self creatButtonWithName:@"漫拍图标88_88" andTime:2];
    [self creatButtonWithName:@"本草百科动画图标88_88" andTime:3];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return contView;
}

- (void)creatButtonWithName:(NSString *)name andTime:(int)time
{
    
    CGFloat padding = (SCREEN_WIDTH - 44 * 4) / 5;
    CGFloat btnX = (time * (padding + 44)) + padding;
    UIButton *creatBtn = [[UIButton alloc]initWithFrame:CGRectMake(btnX, 10, 44, 44)];
    [creatBtn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    creatBtn.tag = time + 1;
    [creatBtn addTarget:self action:@selector(actionClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:creatBtn];
}

-(void)Share:(UIBarButtonItem *)Bbti
{
        NSLog(@"分享");
}

//-(void)SettingBtn:(UIBarButtonItem *)Bbti
//{
//        NSLog(@"设置");
//}

-(void)actionClick:(UIButton *)btn
{
    switch (btn.tag) {
        case 1:
            [self creatActionWithName:@"刷牙动画" andCount:17 andMusic:@"刷牙音乐18秒.wav"];
            break;
            
        case 2:
            [self creatActionWithName:@"原野运动头盔动画" andCount:16 andMusic:@"变形头盔声音.wav"];
            break;
            
        case 3:
            [self creatActionWithName:@"植雅牙膏动画" andCount:5 andMusic:@"植雅音乐.wav"];
            break;
            
        case 4:
            [self creatActionWithName:@"本草百科动画" andCount:17 andMusic:@"本草百科音乐.wav"];
            break;
            
        default:
            break;
    }
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
    [audioPlayer play];
}

-(void)playAutoWithName:(NSString *)name
{
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    if (musicPath) {
        NSURL *musicURL = [NSURL fileURLWithPath:musicPath];
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
        [audioPlayer setDelegate:self];
    }
}

- (void)creatActionWithName:(NSString *)name andCount:(int)count andMusic:(NSString *)mName
{
    [self runAnimationWithCount:count name:name];
    
    [self playAutoWithName:mName];
    if ([audioPlayer isPlaying]) {
        [audioPlayer stop];
    }
    else {
        [audioPlayer play];
    }
}

- (void)runAnimationWithCount:(int)count name:(NSString *)name
{
    if (centerView1.isAnimating) return;
    
//    1.加载所有的动画图片
    NSMutableArray *images = [NSMutableArray array];
    NSString *filename;
    
    for (int i = 0; i<count; i++) {
//        计算文件名
        filename = [NSString stringWithFormat:@"%@%04d.png",name, i+1];
//        加载图片
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:filename ofType:nil];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        
//        添加图片到数组中
        [images addObject:image];
    }
    centerView1.animationImages = images;
    
//    2.设置播放次数(1次)
    centerView1.animationRepeatCount = 1;
    
//     3.设置播放时间
    centerView1.animationDuration = images.count * 0.4;
    
    if ([centerView1 isAnimating]) {
        [centerView1 stopAnimating];
    }
    else {
        [centerView1 startAnimating];
    }
    
    filename = [NSString stringWithFormat:@"%@0001",name];
    centerView1.image = [UIImage imageNamed:filename];
//     4.动画放完1秒后清除内存
    CGFloat delay = centerView1.animationDuration + 1.0;
    [centerView1 performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:delay];
}

-(void)openCameraOrPhoto:(UIButton *)btn
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 分别3个创建操作
    UIAlertAction *camaraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // 普通按键
        [self actionDidDismissWithButtonIndex:0];
    }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // 红色按键
        [self actionDidDismissWithButtonIndex:1];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        // 取消按键
        [self actionDidDismissWithButtonIndex:2];
    }];
    
    // 添加操作（顺序就是呈现的上下顺序）
    [alertController addAction:camaraAction];
    [alertController addAction:photoAction];
    [alertController addAction:cancelAction];
    
    // 呈现警告视图
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)actionDidDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIImagePickerControllerSourceType sType = UIImagePickerControllerSourceTypePhotoLibrary;
    switch (buttonIndex) {
        case 0:
            //            相机
            if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] || [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
                sType = UIImagePickerControllerSourceTypeCamera;
            }
            else
            {
                sType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            break;
        case 1:
            //            相册
            sType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        case 2:
            //            取消
            return;
            break;
    }
    UIImagePickerController *imagePick = [[UIImagePickerController alloc] init];
    imagePick.sourceType = sType;
    imagePick.delegate = self;
    [self presentViewController:imagePick animated:YES completion:nil];
}

#pragma 相机的代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //    NSLog(@"%@",info);
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if (image.imageOrientation == UIImageOrientationUp)
    {
        contView.image = image;
    }
    else
    {
         UIImage *image1 = [self fixOrientation:image];
        contView.image = image1;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//    判断拍照图片的方向，如果不是垂直向下就旋转
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation)
    {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation)
    {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height, CGImageGetBitsPerComponent(aImage.CGImage), 0, CGImageGetColorSpace(aImage.CGImage), CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
