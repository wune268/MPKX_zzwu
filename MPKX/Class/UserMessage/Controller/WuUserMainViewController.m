//
//  WuUserMainViewController.m
//  MPKX
//
//  Created by zzwu on 15/11/21.
//  Copyright © 2015年 zzwu. All rights reserved.
//

#import "WuUserMainViewController.h"
#import "WuUserGroup.h"
#import "WuUserArrowItem.h"
#import "WuUserSwitchItem.h"
#import "WuUserItems.h"
#import "WuProductionViewController.h"
#import "WuSetTtingViewController.h"
#import "WuIntegralViewController.h"
#import "WuHelpViewController.h"
#import "WuFeedbackViewController.h"
#import "WuAboutViewController.h"
#import "WuUserLoginViewController.h"
#import "WuClipCircleView.h"
#import "WuQRCodeScannerController.h"
#import "AFNetworking.h"

#define Screen_Height [UIScreen mainScreen].bounds.size.height
#define Screen_Width [UIScreen mainScreen].bounds.size.width

@interface WuUserMainViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,weak)UIImageView *iconImage;

@end

@implementation WuUserMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupGroup0];
    [self setupGroup1];
}

//    设置数据转成模型
- (void)setupGroup0
{
    WuUserItems *production = [WuUserArrowItem itemWithIcon:nil title:@"我的作品" destVclass:[WuProductionViewController class]];
    WuUserItems *integral = [WuUserArrowItem itemWithIcon:nil title:@"积分" destVclass:[WuIntegralViewController class]];
    WuUserItems *setting = [WuUserArrowItem itemWithIcon:nil title:@"设置" destVclass:[WuSetTtingViewController class]];
    WuUserItems *help = [WuUserArrowItem itemWithIcon:nil title:@"帮助" destVclass:[WuHelpViewController class]];
    WuUserItems *feedback = [WuUserArrowItem itemWithIcon:nil title:@"意见反馈" destVclass:[WuFeedbackViewController class]];
    WuUserItems *about = [WuUserArrowItem itemWithIcon:nil title:@"关于我们" destVclass:[WuAboutViewController class]];
    
    WuUserGroup *group = [[WuUserGroup alloc] init];
    group.items = @[production, integral, setting, help, feedback, about];
    [self.data addObject:group];
}

-(void)setupGroup1
{
    WuUserArrowItem *backReturn = [WuUserArrowItem itemWithTitle:@"退出当前账号"];
    backReturn.option = ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        // 分别创建操作
        UIAlertAction *YesAction = [UIAlertAction actionWithTitle:@"确定退出了吗？" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            
            NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *accountFile = [doc stringByAppendingPathComponent:@"account.data"];
            
            NSFileManager * fileManager = [[NSFileManager alloc]init];
            [fileManager removeItemAtPath:accountFile error:nil];
            //            退出操作
            WuUserLoginViewController *userLoginController = [[WuUserLoginViewController alloc] init];
            UINavigationController *naV = [[UINavigationController alloc] initWithRootViewController:userLoginController];
            [self presentViewController:naV animated:YES completion:^{
                
            }];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            // 取消按键
        }];
        
        // 添加操作（顺序就是呈现的上下顺序）
        [alertController addAction:YesAction];
        [alertController addAction:cancelAction];
        
        // 呈现警告视图
        [self presentViewController:alertController animated:YES completion:nil];
    };
    WuUserGroup *group = [[WuUserGroup alloc] init];
    group.items = @[backReturn];
    [self.data addObject:group];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//    创建头部view高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}

//    创建头部视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
#pragma 解析用户名
//        // 2.1.设置请求路径
//        NSString *urlStr = [NSString stringWithFormat:@"http://52.192.161.238:8000/api-token-decode/"];
//        // 设置请求体
//        NSString *phoneNum = self.userName.text;
//        NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:phoneNum, @"mobile", nil];
//        
//        [self requestHttpWithString:urlStr httpBody:param contentType:@"application/json" key:@"send"];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, Screen_Width, 100)];
        
        WuClipCircleView *iconView = [[WuClipCircleView alloc] initWithFrame:CGRectMake(20, 20, 60, 60)];
        iconView.borderColor = [UIColor blackColor];
        iconView.borderWidth = 2;
        UIImageView *iconImage = [[UIImageView alloc] initWithFrame:iconView.bounds];
        iconImage.image = [UIImage imageNamed:@"qqstar4"];
        [iconView addSubview:iconImage];
        self.iconImage = iconImage;
        UITapGestureRecognizer *iconViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconViewTap:)];
        [iconView addGestureRecognizer:iconViewTap];
        
        [view addSubview:iconView];
        
        UILabel *userText = [[UILabel alloc] initWithFrame:CGRectMake(90, 30, 100, 25)];
        userText.text = @"用户名";
#warning 获取用户的用户名
//        UITapGestureRecognizer *userTextTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTextTap:)];
//        [userText addGestureRecognizer:userTextTap];
//        userText.userInteractionEnabled = YES;
        [view addSubview:userText];
        
        UIView *codeView = [[UIView alloc] initWithFrame:CGRectMake(Screen_Width - 80, 20, 50, 50)];
        codeView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"qrcode_scanner"]];
        UITapGestureRecognizer *scannerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(codeViewClick:)];
        [codeView addGestureRecognizer:scannerTap];
        [view addSubview:codeView];
        
        return view;
    }
    return nil;
}

//-(void)requestHttpWithString:(NSString *)postURL httpBody:(NSDictionary *)dictBody contentType:(NSString *)Type key:(NSString *)key
//{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    //申明返回的结果是json类型
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    //申明请求的数据是json类型
//    manager.requestSerializer=[AFJSONRequestSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:Type];
//    
//    [manager POST:postURL parameters:dictBody success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
////        if ([key isEqualToString:@"send"]) {
////            NSDictionary *jsonInfo = [responseObject objectForKey:@"open_sms_sendvercode_response"];
////            NSDictionary *result = [jsonInfo objectForKey:@"result"];
////            NSString *str = [NSString stringWithFormat:@"%@",[result objectForKey:@"message"]];
////            NSLog(@"jsonInfo字典里面的内容为--》%@", str);
////            [MBProgressHUD showSuccess:@"验证码已经成功发放到您的手机上"];
////        }
////        else if ([key isEqualToString:@"set"])
////        {
////            NSString *str = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
////            NSLog(@"jsonInfo字典里面的内容为--》%@", str);
////            if ([str isEqualToString:@"set new password"]) {
////                [MBProgressHUD showSuccess:@"密码设置成功"];
////                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
////            }
////            else
////            {
////                [MBProgressHUD showSuccess:@"验证码已经过期，请重新获取验证码"];
////            }
////        }
//        
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        NSLog(@"网络出错或服务器内部发生未知错误");
//    }];
//}

#pragma 二维码扫描
-(void)codeViewClick:(UIGestureRecognizer *)gestureRecognizer
{
    WuQRCodeScannerController *QRCode = [[WuQRCodeScannerController alloc] init];
    [self.navigationController pushViewController:QRCode animated:YES];
}

//#pragma 用户登录
//-(void)userTextTap:(UIGestureRecognizer *)gestureRecognizer
//{
//    WuUserLoginViewController *loginController = [[WuUserLoginViewController alloc] init];
//    [self.navigationController pushViewController:loginController animated:YES];
//}

#pragma 更换头像
-(void)iconViewTap:(UIGestureRecognizer *)gestureRecognizer
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
    self.iconImage.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
