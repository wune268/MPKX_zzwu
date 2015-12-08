//
//  WuViewController.m
//  MPKX
//
//  Created by zzwu on 15/12/8.
//  Copyright © 2015年 zzwu. All rights reserved.
//

#import "WuViewController.h"
#import "WuMessage.h"
#import "WuMessageFrame.h"
#import "WuMessageViewCell.h"
#import "WuButton.h"

#define Screen_Height [UIScreen mainScreen].bounds.size.height
#define Screen_Width [UIScreen mainScreen].bounds.size.width

@interface WuViewController () <UITableViewDataSource, UITableViewDelegate, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic)UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *messageFrames;

@property (weak, nonatomic)UITextField *inputView;

@property (nonatomic, strong) NSDictionary *autoreply;
@end

@implementation WuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self creatView];
    
    // 监听键盘的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)creatView
{
//    感情温度计
    UIView *goodView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 200)];
    goodView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:goodView];
    // 表格的设置
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 200, Screen_Width, Screen_Height - 244)];
    self.tableView = tableView;
    // 去除分割线
    self.tableView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO; // 不允许选中
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    CGFloat tabbarViewH = 44;
    //    设置文本输入框位置
    UIView *tabbarView = [[UIView alloc]initWithFrame:CGRectMake(0, Screen_Height - 44, Screen_Width, tabbarViewH)];
    tabbarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbarbg"]];
    //    self.tabbarView = tabbarView;
    
    //    添加声音按钮
    WuButton *soundBtn = [WuButton buttonWithImage:[UIImage imageNamed:@"sound"] highlightedImage:nil selectImage:nil frame:CGRectMake(0, 0, tabbarViewH, tabbarViewH)];
    [soundBtn addTarget:self action:@selector(soundBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tabbarView addSubview:soundBtn];
    
    //    添加文本框位置
    UITextField *chatField = [[UITextField alloc]initWithFrame:CGRectMake(tabbarViewH, 8, Screen_Width - 3 * tabbarViewH, tabbarViewH - 16)];
    chatField.borderStyle = UITextBorderStyleRoundedRect;
    chatField.returnKeyType = UIReturnKeySend;
    chatField.enablesReturnKeyAutomatically = YES;
    chatField.delegate = self;
    chatField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    // 永远显示
    chatField.leftViewMode = UITextFieldViewModeAlways;
    [tabbarView addSubview:chatField];
    self.inputView = chatField;
    
    //    添加表情按钮
    WuButton *smileBtn = [WuButton buttonWithImage:[UIImage imageNamed:@"Expression"] highlightedImage:nil selectImage:nil frame:CGRectMake(Screen_Width - 2 * tabbarViewH, 0, tabbarViewH, tabbarViewH)];
    [smileBtn addTarget:self action:@selector(smileBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tabbarView addSubview:smileBtn];
    
    //    添加更多按钮
    WuButton *addBtn = [WuButton buttonWithImage:[UIImage imageNamed:@"add"] highlightedImage:nil selectImage:nil frame:CGRectMake(Screen_Width - tabbarViewH, 0, tabbarViewH, tabbarViewH)];
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tabbarView addSubview:addBtn];
    
    [self.view addSubview:tableView];
    [self.view addSubview:tabbarView];
    
//    自动滚动到最后一行
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:self.messageFrames.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

// 声音
-(void)soundBtnClick:(UIButton *)btn
{
    NSLog(@"soundBtnClick");
}

// 表情
-(void)smileBtnClick:(UIButton *)btn
{
    NSLog(@"smileBtnClick");
}

// 更多
-(void)addBtnClick:(UIButton *)btn
{
    NSLog(@"addBtnClick");
}

/**
 *  发送一条消息
 */
- (void)addMessage:(NSString *)text type:(WuMessageType)type
{
    // 1.数据模型
    WuMessage *msg = [[WuMessage alloc] init];
    msg.type = type;
    msg.text = text;
    // 设置数据模型的时间
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"HH:mm";
    msg.time = [fmt stringFromDate:now];
    
    // 看是否需要隐藏时间
    WuMessageFrame *lastMf = [self.messageFrames lastObject];
    WuMessage *lastMsg = lastMf.message;
    msg.hideTime = [msg.time isEqualToString:lastMsg.time];
    
    // 2.frame模型
    WuMessageFrame *mf = [[WuMessageFrame alloc] init];
    mf.message = msg;
    [self.messageFrames addObject:mf];
    
    // 3.刷新表格
    [self.tableView reloadData];
    
    // 4.自动滚动表格到最后一行
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:self.messageFrames.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

/**
 *  根据自己发的内容取得自动回复的内容
 *
 *  @param text 自己发的内容
 */
- (NSString *)replayWithText:(NSString *)text
{
    for (int i = 0; i < text.length; i++) {
        
        NSString *word = [text substringWithRange:NSMakeRange(i, 1)];
        if (self.autoreply[word])
            return self.autoreply[word];
    }
    
    return @"滚蛋";
}

#pragma mark - 文本框代理
/**
 *  点击了return按钮(键盘最右下角的按钮)就会调用
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 1.自己发一条消息
    [self addMessage:textField.text type:WuMessageTypeMe];
    
    // 2.自动回复一条消息
    NSString *reply = [self replayWithText:textField.text];
    [self addMessage:reply type:WuMessageTypeOther];
    
    // 3.清空文字
    self.inputView.text = nil;
    
    // 返回YES即可
    return YES;
}

/**
 *  当键盘改变了frame(位置和尺寸)的时候调用
 */
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 设置窗口的颜色
    self.view.window.backgroundColor = self.tableView.backgroundColor;
    
    // 0.取出键盘动画的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 1.取得键盘最后的frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 2.计算控制器的view需要平移的距离
    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height;
    
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, transformY);
    }];
}

- (NSDictionary *)autoreply
{
    if (_autoreply == nil) {
        _autoreply = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"autoreply.plist" ofType:nil]];
    }
    return _autoreply;
}

- (NSMutableArray *)messageFrames
{
    if (_messageFrames == nil) {
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"messages.plist" ofType:nil]];
        
        NSMutableArray *mfArray = [NSMutableArray array];
        
        for (NSDictionary *dict in dictArray) {
            // 消息模型
            WuMessage *msg = [WuMessage messageWithDict:dict];
            
            // 取出上一个模型
            WuMessageFrame *lastMf = [mfArray lastObject];
            WuMessage *lastMsg = lastMf.message;
            
            // 判断两个消息的时间是否一致
            msg.hideTime = [msg.time isEqualToString:lastMsg.time];
            
            // frame模型
            WuMessageFrame *mf = [[WuMessageFrame alloc] init];
            mf.message = msg;
            
            // 添加模型
            [mfArray addObject:mf];
        }
        
        _messageFrames = mfArray;
    }
    return _messageFrames;
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    WuMessageViewCell *cell = [WuMessageViewCell cellWithTableView:tableView];
    
    // 2.给cell传递模型
    cell.messageFrame = self.messageFrames[indexPath.row];
    
    // 3.返回cell
    return cell;
}

#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WuMessageFrame *mf = self.messageFrames[indexPath.row];
    return mf.cellHeight;
}

/**
 *  当开始拖拽表格的时候就会调用
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 退出键盘
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
