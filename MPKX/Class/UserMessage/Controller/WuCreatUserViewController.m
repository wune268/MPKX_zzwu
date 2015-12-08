//
//  WuCreatUserViewController.m
//  MPKX
//
//  Created by zzwu on 15/11/21.
//  Copyright © 2015年 zzwu. All rights reserved.
//

#import "WuCreatUserViewController.h"
#import "NSString+Hash.h"
#import "WuClipCircleView.h"
#import "WuPassWordField.h"
#import "WuAnimationView.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"

#define Screen_Height [UIScreen mainScreen].bounds.size.height
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define SEC 60

@interface WuCreatUserViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)UITextField *userName;
@property(nonatomic,strong)UITextField *codeName;
@property(nonatomic,strong)WuPassWordField *passWord1;
@property(nonatomic,strong)WuPassWordField *passWord2;
@property(nonatomic,weak)UIView *creatLoginView;
@property(nonatomic,strong)UIButton *codeBtn;
@property(nonatomic,assign)int randomNum;
@property(nonatomic,weak)UIImageView *icon;

@end

@implementation WuCreatUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)creatView
{
    CGFloat creatLoginViewX = 70;
    CGFloat creatLoginViewY = 214;
    CGFloat creatLoginViewW = Screen_Width - creatLoginViewX * 2;
    CGFloat creatLoginViewH = Screen_Height - creatLoginViewY * 2;
    
    WuClipCircleView *iconView = [[WuClipCircleView alloc] initWithFrame:CGRectMake((Screen_Width - 130) * 0.5, 74, 130, 130)];
    iconView.borderColor = [UIColor blackColor];
    iconView.borderWidth = 5;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:iconView.bounds];
    imageView.image = [UIImage imageNamed:@"qqstar4"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectIcon:)];
    self.icon = imageView;
    [iconView addGestureRecognizer:tap];
    [iconView addSubview:imageView];
    [self.view addSubview:iconView];
    
    UIView *creatLoginView = [[UIView alloc] initWithFrame:CGRectMake(creatLoginViewX, creatLoginViewY, creatLoginViewW, creatLoginViewH)];
    creatLoginView.backgroundColor = [UIColor clearColor];
    self.creatLoginView = creatLoginView;
    [self.view addSubview:self.creatLoginView];
    UITextField *userName = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, creatLoginViewW - 20, 40)];
    userName.placeholder = @"请输入手机号码注册";
    userName.returnKeyType = UIReturnKeyNext;
    userName.keyboardType = UIKeyboardTypeNumberPad;
    userName.borderStyle = UITextBorderStyleRoundedRect;
    userName.enablesReturnKeyAutomatically = YES;
    userName.clearButtonMode = UITextFieldViewModeAlways;
    userName.delegate = self;
    self.userName = userName;
    
    CGFloat pading = creatLoginViewW - 80;
    
    UITextField *codeName = [[UITextField alloc] initWithFrame:CGRectMake(10, 50, pading - 20, 40)];
    codeName.placeholder = @"请输入验证码";
    codeName.keyboardType = UIKeyboardTypeNumberPad;
    codeName.returnKeyType = UIReturnKeyNext;
    codeName.borderStyle = UITextBorderStyleRoundedRect;
    codeName.enablesReturnKeyAutomatically = YES;
    codeName.clearButtonMode = UITextFieldViewModeAlways;
    codeName.tag = 888;
    codeName.delegate = self;
    self.codeName = codeName;
    
    UIButton *getCodeName = [[UIButton alloc] initWithFrame:CGRectMake(pading, 50, 70, 40)];
    [getCodeName setTitle:@"获取验证码" forState:UIControlStateNormal];
    getCodeName.titleLabel.font = [UIFont systemFontOfSize:13];
    [getCodeName addTarget:self action:@selector(getCodeNameClick:) forControlEvents:UIControlEventTouchUpInside];
    [getCodeName.layer setCornerRadius:5];
    getCodeName.backgroundColor = [UIColor grayColor];
    self.codeBtn = getCodeName;
    
    WuPassWordField *passWord1 = [[WuPassWordField alloc] initWithFrame:CGRectMake(10, 100, creatLoginViewW - 20, 40) placeholder:@"请输入密码"];
    passWord1.delegate = self;
    self.passWord1 = passWord1;
    
    WuPassWordField *passWord2 = [[WuPassWordField alloc] initWithFrame:CGRectMake(10, 150, creatLoginViewW - 20, 40) placeholder:@"请再次确认密码" ];
    passWord2.delegate = self;
    self.passWord2 = passWord2;
    
    UIButton *userCreat = [[UIButton alloc] initWithFrame:CGRectMake(10, 200, creatLoginViewW - 20, 35)];
    [userCreat setTitle:@"注册" forState:UIControlStateNormal];
    [userCreat setTitle:@"注册" forState:UIControlStateHighlighted];
    [userCreat addTarget:self action:@selector(creatUserClick:) forControlEvents:UIControlEventTouchUpInside];
    [userCreat.layer setCornerRadius:5];
    userCreat.backgroundColor = [UIColor grayColor];
    
    UIButton *userLogin = [[UIButton alloc] initWithFrame:CGRectMake(Screen_Width - 80, Screen_Height - 64, 70, 30)];
    [userLogin setTitle:@"返回登录" forState:UIControlStateNormal];
    [userLogin setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [userLogin setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    userLogin.titleLabel.font = [UIFont systemFontOfSize:11];
    [userLogin addTarget:self action:@selector(userLoginClick:) forControlEvents:UIControlEventTouchUpInside];
    [userLogin.layer setCornerRadius:5];
    
    [self.creatLoginView addSubview:userCreat];
    [self.creatLoginView addSubview:userName];
    [self.creatLoginView addSubview:passWord1];
    [self.creatLoginView addSubview:passWord2];
    [self.creatLoginView addSubview:codeName];
    [self.creatLoginView addSubview:getCodeName];
    [self.view addSubview:userLogin];
}

-(void)selectIcon:(UITapGestureRecognizer *)tap
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
    self.icon.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resignOneResponder];
    return YES;
}

-(void)getCodeNameClick:(UIButton *)button
{
    [self resignOneResponder];
    self.randomNum = (arc4random() % 10000);
    if (self.userName.text.length == 0)
    {
        [WuAnimationView shakeAnimationForView:self.creatLoginView];
        [MBProgressHUD showError:@"请输入手机号码！"];
    }
    else if(self.userName.text.length == 11)
    {
//        获取倒计时
        [self performSelector:@selector(reflashGetKeyBt:) withObject:[NSNumber numberWithInt:SEC] afterDelay:0];
        self.codeBtn.enabled = NO;
        
        // 2.1.设置请求路径
        NSString *urlStr = [NSString stringWithFormat:@"http://52.192.161.238:8000/regin_send_vercode/"];
        // 设置请求体
        NSString *phoneNum = self.userName.text;
        NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:phoneNum, @"mobile", nil];
        
        [self requestHttpWithString:urlStr httpBody:param contentType:@"application/json" key:@"send"];
    }
}

-(void)creatUserClick:(UIButton *)button
{
    [self resignOneResponder];
    
    if (self.userName.text.length == 0 || self.passWord1.text.length == 0 || self.passWord2.text.length == 0 || self.codeName.text.length == 0) {
        [MBProgressHUD showError:@"请输入验证码或密码"];
        [WuAnimationView shakeAnimationForView:self.creatLoginView];
    }
    else if (self.passWord1.text.length == 0 || self.passWord2.text.length == 0)
    {
        [MBProgressHUD showError:@"用户名或密码为空"];
        [WuAnimationView shakeAnimationForView:self.creatLoginView];
    }
    else if (self.userName.text.length == 11)
    {
        if ([self.passWord1.text isEqualToString:self.passWord2.text])
        {
            // 2.1.设置请求路径
            NSString *urlStr = [NSString stringWithFormat:@"http://52.192.161.238:8000/regin_set_password/"];
            // 设置请求体
#warning 密码加密
            NSString *password = [self.passWord1.text md5String];
            password = [password md5String];
            NSLog(@"%@password",password);
            NSString *numP = self.userName.text;
            NSString *rand = [NSString stringWithFormat:@"%d", self.randomNum];
            NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:numP, @"mobile", password, @"password", rand, @"random_code",nil];
            [self requestHttpWithString:urlStr httpBody:param contentType:@"application/json" key:@"set"];
            NSLog(@"%d",self.randomNum);
        }
        else
        {
            [MBProgressHUD showError:@"两次输入的密码不一致"];
            [WuAnimationView shakeAnimationForView:self.creatLoginView];
        }
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self resignOneResponder];
}

-(void)resignOneResponder
{
    [self.userName resignFirstResponder];
    [self.passWord1 resignFirstResponder];
    [self.passWord2 resignFirstResponder];
    [self.codeName resignFirstResponder];
}

//倒数
- (void)reflashGetKeyBt:(NSNumber *)second
{
    if ([second integerValue] == 0)
    {
        [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.codeBtn.enabled = YES;
    }
    else
    {
        int i = [second intValue];
        NSString *text=[NSString stringWithFormat:@"%2i秒后重发",i];
        [self.codeBtn setTitle:text forState:UIControlStateNormal];
        [self performSelector:@selector(reflashGetKeyBt:) withObject:[NSNumber numberWithInt:i-1] afterDelay:1];
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 888) {
        if (self.codeName.text.length) {
            // 2.1.设置请求路径
            NSString *urlStr = [NSString stringWithFormat:@"http://52.192.161.238:8000/regin_check_vercode/"];
            NSString *numP = self.userName.text;
            NSString *code = self.codeName.text;
            NSString *rand = [NSString stringWithFormat:@"%d", self.randomNum];
            // 设置请求体
            NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:numP, @"mobile", code, @"ver_code", rand, @"random_code",nil];
            [self requestHttpWithString:urlStr httpBody:param contentType:@"application/json" key:nil];
            NSLog(@"%d－－randomNum",self.randomNum);
        }
    }
}

-(void)requestHttpWithString:(NSString *)postURL httpBody:(NSDictionary *)dictBody contentType:(NSString *)Type key:(NSString *)key
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:Type];
    
    [manager POST:postURL parameters:dictBody success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([key isEqualToString:@"send"]) {
            NSDictionary *jsonInfo = [responseObject objectForKey:@"open_sms_sendvercode_response"];
            NSDictionary *result = [jsonInfo objectForKey:@"result"];
            NSString *str = [NSString stringWithFormat:@"%@",[result objectForKey:@"message"]];
            NSLog(@"jsonInfo字典里面的内容为--》%@", str);
            [MBProgressHUD showSuccess:@"验证码已经成功发放到您的手机上"];
        }
        else if ([key isEqualToString:@"set"])
        {
            NSString *str = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
            NSLog(@"jsonInfo字典里面的内容为--》%@", str);
            if ([str isEqualToString:@"set new password"]) {
                [MBProgressHUD showSuccess:@"密码设置成功"];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                [MBProgressHUD showSuccess:@"验证码已经过期，请重新获取验证码"];
            }
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"网络出错或服务器内部发生未知错误");
    }];
}

-(void)userLoginClick:(UIButton *)button
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
