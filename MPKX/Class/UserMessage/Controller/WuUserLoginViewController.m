//
//  WuUserLoginViewController.m
//  MPKX
//
//  Created by zzwu on 15/11/21.
//  Copyright © 2015年 zzwu. All rights reserved.
//

#import "WuUserLoginViewController.h"
#import "WuCreatUserViewController.h"
#import "NSString+Hash.h"
#import "WuClipCircleView.h"
//#import "WuLabel.h"
#import "WuPassWordField.h"
#import "WuAnimationView.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"
#import "WuAccount.h"
#import "WuMainViewController.h"

#define Screen_Height [UIScreen mainScreen].bounds.size.height
#define Screen_Width [UIScreen mainScreen].bounds.size.width

@interface WuUserLoginViewController ()<UITextFieldDelegate>

@property(nonatomic,weak)UITextField *userName;
@property(nonatomic,weak)WuPassWordField *passWord;
@property(nonatomic,weak)UIView *loginView;
//@property(nonatomic,strong)WuLabel *label;

@end

@implementation WuUserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"欢迎登录";
    [self creatView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(WuLabel *)label
//{
//    if (_label == nil) {
//        _label = [[WuLabel alloc] initWithFrame:CGRectMake(0, 0, 150, 25) text:[NSString stringWithFormat:@"用户名或密码错误"]];
//        _label.center = CGPointMake(Screen_Width * 0.5, Screen_Height * 0.4);
//        [self.view addSubview:_label];
//    }
//    return _label;
//}

-(void)creatView
{
    CGFloat loginViewX = 70;
    CGFloat loginViewY = 265;
    CGFloat loginViewW = Screen_Width - loginViewX * 2;
    CGFloat loginViewH = Screen_Height - loginViewY * 2;
    
    WuClipCircleView *iconView = [[WuClipCircleView alloc] initWithFrame:CGRectMake((Screen_Width - 150) * 0.5, 90, 150, 150)];
    iconView.borderColor = [UIColor blackColor];
    iconView.borderWidth = 5;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:iconView.bounds];
    imageView.image = [UIImage imageNamed:@"qqstar4"];
    [iconView addSubview:imageView];
    [self.view addSubview:iconView];
    
    UIView *loginView = [[UIView alloc] initWithFrame:CGRectMake(loginViewX, loginViewY, loginViewW, loginViewH)];
    self.loginView = loginView;
    [self.view addSubview:loginView];
    
    UITextField *userName = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, loginViewW - 20, 40)];
    userName.placeholder = @"请输入手机号码";
    userName.returnKeyType = UIReturnKeyNext;
    userName.keyboardType = UIKeyboardTypeNumberPad;
    userName.borderStyle = UITextBorderStyleRoundedRect;
    userName.enablesReturnKeyAutomatically = YES;
    userName.clearButtonMode = UITextFieldViewModeAlways;
    userName.delegate = self;
    self.userName = userName;
    
    WuPassWordField *passWord = [[WuPassWordField alloc] initWithFrame:CGRectMake(10, 50, loginViewW - 20, 40) placeholder:@"请输入密码"];
    passWord.delegate = self;
    self.passWord = passWord;
    
    UIButton *userLogin = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, loginViewW - 20, 40)];
    [userLogin setTitle:@"登陆" forState:UIControlStateNormal];
    [userLogin addTarget:self action:@selector(userLoginClick:) forControlEvents:UIControlEventTouchUpInside];
    [userLogin.layer setCornerRadius:5];
    userLogin.backgroundColor = [UIColor grayColor];
    
    UIButton *creatUser = [[UIButton alloc] initWithFrame:CGRectMake(Screen_Width - 80, Screen_Height - 64, 70, 30)];
    [creatUser setTitle:@"新用户" forState:UIControlStateNormal];
    [creatUser setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [creatUser setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    creatUser.titleLabel.font = [UIFont systemFontOfSize:11];
    [creatUser addTarget:self action:@selector(creatUserClick:) forControlEvents:UIControlEventTouchUpInside];
    [creatUser.layer setCornerRadius:5];
    
    [loginView addSubview:userLogin];
    [loginView addSubview:userName];
    [loginView addSubview:passWord];
    [self.view addSubview:creatUser];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.userName resignFirstResponder];
    [self.passWord resignFirstResponder];
    return YES;
}

-(void)userLoginClick:(UIButton *)button
{
    [self.userName resignFirstResponder];
    [self.passWord resignFirstResponder];
    if (self.userName.text.length == 0 || self.passWord.text.length == 0)
    {
        [WuAnimationView shakeAnimationForView:self.loginView];
        
        [MBProgressHUD showError:@"用户名或密码为空！"];
    }
    else
    {
#warning 发送网络请求，获取用户登录信息
        NSString *urlStr = [NSString stringWithFormat:@"http://52.192.161.238:8000/api-token-auth/"];
        NSString *username = self.userName.text;
        
        NSString *password = [self.passWord.text md5String];
        password = [password md5String];
        NSLog(@"%@__password",password);
        NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:username, @"phone", password, @"password", nil];
        [self requestHttpWithString:urlStr httpBody:param contentType:@"application/json" key:nil];
    }
}

-(void)requestHttpWithString:(NSString *)postURL httpBody:(NSDictionary *)dictBody contentType:(NSString *)Type key:(NSString *)key
{
    // 1.创建请求
    NSURL *url = [NSURL URLWithString:postURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 2.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // 3.设置请求体
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictBody options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = data;
    
    // 4.发送请求
//    + (void)sendAsynchronousRequest:(NSURLRequest*) request
//queue:(NSOperationQueue*) queue
//completionHandler:(void (^)(NSURLResponse* __nullable response, NSData* __nullable data, NSError* __nullable connectionError)) handler NS_DEPRECATED(10_7, 10_11, 5_0, 9_0, "Use [NSURLSession dataTaskWithRequest:completionHandler:] (see NSURLSession.h");
//    Use [NSURLSession dataTaskWithRequest:completionHandler:] (see NSURLSession.h"
    
//    [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"%lu", (unsigned long)data.length);
////        NSError *error;
//        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
//        NSDictionary *jsonError = [jsonData objectForKey:@"non_field_errors"];
//        NSDictionary *jsonToken = [jsonData objectForKey:@"token"];
//        if (jsonToken) {
//            NSLog(@"%@jsonToken",jsonToken);
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//        else if (jsonError)
//        {
//            NSLog(@"%@jsonError",jsonError);
//            [WuAnimationView shakeAnimationForView:self.loginView];
//            [MBProgressHUD showError:@"用户名或密码错误"];
//        }
//    }];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"%lu", (unsigned long)data.length);
        NSError *error;
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSDictionary *jsonError = [jsonData objectForKey:@"non_field_errors"];
        NSDictionary *jsonToken = [jsonData objectForKey:@"token"];
        if (jsonToken) {
//            字典转模型
            WuAccount *account = [WuAccount accountWithDict:jsonData];
//            存储模型数据
            NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *accountFile = [doc stringByAppendingPathComponent:@"account.data"];
            [NSKeyedArchiver archiveRootObject:account toFile:accountFile];
////            跳转主页面
            WuMainViewController *mainController = [[WuMainViewController alloc] init];
            [self.navigationController presentViewController:mainController animated:YES completion:^{
            
            }];
        }
        else if (jsonError)
        {
            NSLog(@"%@jsonError",jsonError);
            [WuAnimationView shakeAnimationForView:self.loginView];
            [MBProgressHUD showError:@"用户名或密码错误"];
        }
    }];
    
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    //申明返回的结果是json类型
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    //申明请求的数据是json类型
//    manager.requestSerializer=[AFJSONRequestSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:Type];
//    
//    [manager POST:postURL parameters:dictBody success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSLog(@"%@",responseObject);
//
//        [self.navigationController popViewControllerAnimated:YES];
////        验证token
////        NSString *urlStr = [NSString stringWithFormat:@"http://52.192.161.238:8000/api-token-verify/"];
////        token解析用户的手机号
////        NSString *urlStr = [NSString stringWithFormat:@"http://52.192.161.238:8000/api-token-decode/"];
////        刷新token
////        NSString *urlStr = [NSString stringWithFormat:@"http://52.192.161.238:8000/api-token-refresh/"];
//        
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        NSLog(@"网络出错或服务器内部发生未知错误%@",error);
//    }];
}

//-(void)alerUser:(WuLabel *)label
//{
//    [UIView animateWithDuration:1.0 animations:^{
//        label.alpha = 0.5;
//    } completion:^(BOOL finished) {
//        label.alpha = 0.0;
//    }];
//}
//
//-(void)tokenHttpWithString:(NSString *)postURL httpBody:(NSDictionary *)dictBody contentType:(NSString *)Type
//{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    //申明返回的结果是json类型
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    //申明请求的数据是json类型
//    manager.requestSerializer=[AFJSONRequestSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:Type];
//    
////    manager.responseSerializer setva
////    [manager.requestSerializer setValue:xx forHTTPHeaderField:xx]
//    
//    [manager POST:postURL parameters:dictBody success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject1) {
//        NSLog(@"%@------responseObject",responseObject1);
////        if (jsonToken) {
////            NSLog(@"%@jsonToken",jsonToken);
//            //            [self.navigationController popViewControllerAnimated:YES];
//            //            字典转模型
//            WuAccount *account = [WuAccount accountWithDict:responseObject1];
//            //            存储模型数据
//            NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//            NSString *accountFile = [doc stringByAppendingPathComponent:@"account.data"];
//            [NSKeyedArchiver archiveRootObject:account toFile:accountFile];
//            //            跳转主页面
//            WuMainViewController *mainController = [[WuMainViewController alloc] init];
//            [self.navigationController presentViewController:mainController animated:YES completion:^{
//                
//            }];
//
//        
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        NSLog(@"网络出错或服务器内部发生未知错误%@",error);
//    }];
//}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.userName resignFirstResponder];
    [self.passWord resignFirstResponder];
}

-(void)creatUserClick:(UIButton *)button
{
    [self.userName resignFirstResponder];
    [self.passWord resignFirstResponder];
    WuCreatUserViewController *creatUserViewController = [[WuCreatUserViewController alloc] init];
    creatUserViewController.title = @"注册新用户";
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:creatUserViewController];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

@end
