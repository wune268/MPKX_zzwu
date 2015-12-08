//
//  WuFeedbackViewController.m
//  MPKX
//
//  Created by zzwu on 15/11/21.
//  Copyright © 2015年 zzwu. All rights reserved.
//

#import "WuFeedbackViewController.h"

#define Screen_Height [UIScreen mainScreen].bounds.size.height
#define Screen_Width [UIScreen mainScreen].bounds.size.width

@interface WuFeedbackViewController ()<UITextViewDelegate>

@property(nonatomic,strong)UITextView *textView;

@end

@implementation WuFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    [self creatView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)creatView
{
    CGFloat textViewX = 30;
    CGFloat textViewY = 20;
    CGFloat textViewW = Screen_Width - 2 * textViewX;
    CGFloat textViewH = 200;
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(textViewX, textViewY, textViewW, textViewH)];
    [textView setBackgroundColor:[UIColor yellowColor]];
    textView.delegate = self;
    self.textView = textView;
    [self.view addSubview:textView];

    CGFloat sendBtnY = textViewH + textViewY * 2;
    CGFloat sendBtnW = 60;
    CGFloat sendBtnH = 30;
    CGFloat sendBtnX = Screen_Width - textViewX - sendBtnW;
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(sendBtnX, sendBtnY, sendBtnW, sendBtnH)];
    sendBtn.backgroundColor = [UIColor blueColor];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setImage:[UIImage imageNamed:@"juxing"] forState:UIControlStateHighlighted];
    [sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
}

-(void)sendBtnClick:(UIButton *)button
{
    [self.textView resignFirstResponder];
    NSLog(@"%@",self.textView.text);
}

@end
