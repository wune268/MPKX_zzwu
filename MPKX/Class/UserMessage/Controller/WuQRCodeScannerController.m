//
//  WuQRCodeScanner.m
//  MPKX
//
//  Created by zzwu on 15/11/30.
//  Copyright © 2015年 zzwu. All rights reserved.
//

#import "WuQRCodeScannerController.h"
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD+MJ.h"

#define Screen_Height [UIScreen mainScreen].bounds.size.height
#define Screen_Width [UIScreen mainScreen].bounds.size.width

@interface WuQRCodeScannerController()<AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic)UIView *viewPreview;
@property (weak, nonatomic)UIButton *starButton;

@property (strong, nonatomic) UIView *boxView;
@property (nonatomic) BOOL isReading;
@property (strong, nonatomic) CALayer *scanLayer;

//捕捉会话
@property (nonatomic, strong) AVCaptureSession *captureSession;
//展示layer
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end

@implementation WuQRCodeScannerController

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.captureSession = nil;
    self.isReading = NO;
    
    CGFloat viewPreviewX = 25;
    CGFloat viewPreviewY = 50;
    CGFloat viewPreviewW = Screen_Width - viewPreviewX * 2;
    CGFloat viewPreviewH = viewPreviewW;
    CGFloat starButtonW = 100;
    CGFloat starButtonH = starButtonW;
    CGFloat starButtonX = (Screen_Width - starButtonW) * 0.5;
    CGFloat starButtonY = viewPreviewH + viewPreviewY * 2;
    
    UIView *viewPreview = [[UIView alloc] initWithFrame:CGRectMake(viewPreviewX, viewPreviewY, viewPreviewW, viewPreviewH)];
    viewPreview.backgroundColor = [UIColor redColor];
    self.viewPreview = viewPreview;
    [self.view addSubview:viewPreview];
    
    UIButton *starButton = [[UIButton alloc] initWithFrame:CGRectMake(starButtonX, starButtonY, starButtonW, starButtonH)];
    [starButton setTitle: @"开始扫描" forState:UIControlStateNormal];
    starButton.backgroundColor = [UIColor grayColor];
    [starButton addTarget:self action:@selector(startStopReading:) forControlEvents:UIControlEventTouchUpInside];
    [starButton.layer setCornerRadius:50];
    [self.view addSubview:starButton];
    self.starButton = starButton;
}

-(BOOL)startReading
{
    NSError *error;
    //1.初始化捕捉设备（AVCaptureDevice），类型为AVMediaTypeVideo
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //2.用captureDevice创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    //3.创建媒体数据输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    //4.实例化捕捉会话
    self.captureSession = [[AVCaptureSession alloc] init];
    
    //4.1.将输入流添加到会话
    [self.captureSession addInput:input];
    
    //4.2.将媒体输出流添加到会话中
    [self.captureSession addOutput:captureMetadataOutput];
    
    //5.创建串行队列，并加媒体输出流添加到队列当中
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    //5.1.设置代理
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    
    //5.2.设置输出媒体数据类型为QRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    //6.实例化预览图层
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    
    //7.设置预览图层填充方式
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //8.设置图层的frame
    [self.videoPreviewLayer setFrame:self.viewPreview.layer.bounds];
    
    //9.将图层添加到预览view的图层上
    [self.viewPreview.layer addSublayer:self.videoPreviewLayer];
    
    //10.设置扫描范围
    captureMetadataOutput.rectOfInterest = CGRectMake(0.2f, 0.2f, 0.8f, 0.8f);
    
    //10.1.扫描框
    self.boxView = [[UIView alloc] initWithFrame:CGRectMake(self.viewPreview.bounds.size.width * 0.2f, self.viewPreview.bounds.size.height * 0.2f, self.viewPreview.bounds.size.width - self.viewPreview.bounds.size.width * 0.4f, self.viewPreview.bounds.size.height - self.viewPreview.bounds.size.height * 0.4f)];
    self.boxView.layer.borderColor = [UIColor greenColor].CGColor;
    self.boxView.layer.borderWidth = 1.0f;
    
    [self.viewPreview addSubview:self.boxView];
    
    //10.2.扫描线
    self.scanLayer = [[CALayer alloc] init];
    self.scanLayer.frame = CGRectMake(0, 0, self.boxView.bounds.size.width, 1);
    self.scanLayer.backgroundColor = [UIColor brownColor].CGColor;
    
    [self.boxView.layer addSublayer:self.scanLayer];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(moveScanLayer:) userInfo:nil repeats:YES];
    
    [timer fire];
    
    //10.开始扫描
    [self.captureSession startRunning];

    return YES;
}

- (void)startStopReading:(UIButton *)button {
    if (!self.isReading) {
        if ([self startReading]) {
            [self.starButton setTitle:@"停止扫描" forState:UIControlStateNormal];
        }
    }
    else{
        [self stopReading:nil];
        [self.starButton setTitle:@"开始扫描" forState:UIControlStateNormal];
    }
    
    self.isReading = !self.isReading;
}

-(void)stopReading:(NSString *)string
{
    if (string) {        
        [MBProgressHUD showSuccess:[NSString stringWithFormat:@"扫描结果：%@",string]];
    }
    [self.captureSession stopRunning];
    self.captureSession = nil;
    [self.scanLayer removeFromSuperlayer];
    [self.videoPreviewLayer removeFromSuperlayer];
//    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - AVCaptureMetadataOutput 代理方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        //判断回传的数据类型
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
#warning 获取二维码数据
            NSLog(@"%@--metadataObj",[metadataObj stringValue]);
            [self performSelectorOnMainThread:@selector(stopReading:) withObject:[metadataObj stringValue] waitUntilDone:NO];
            self.isReading = NO;
        }
    }
}

- (void)moveScanLayer:(NSTimer *)timer
{
    CGRect frame = self.scanLayer.frame;
    if (self.boxView.frame.size.height < self.scanLayer.frame.origin.y) {
        frame.origin.y = 0;
        self.scanLayer.frame = frame;
    }else{
        
        frame.origin.y += 5;
        
        [UIView animateWithDuration:0.05 animations:^{
            self.scanLayer.frame = frame;
        }];
    }
}

- (BOOL)shouldAutorotate
{
    return NO;
}


@end
