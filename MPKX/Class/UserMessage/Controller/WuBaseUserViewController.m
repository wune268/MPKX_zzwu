//
//  WuBaseUserViewController.m
//  MPKX
//
//  Created by zzwu on 15/11/21.
//  Copyright © 2015年 zzwu. All rights reserved.
//

#import "WuBaseUserViewController.h"
#import "WuUserItems.h"
#import "WuUserGroup.h"
#import "WuUserArrowItem.h"
#import "WuUserSwitchItem.h"
#import "WuUserTableViewCell.h"

@interface WuBaseUserViewController ()

@end

@implementation WuBaseUserViewController

- (id)init
{
//    隐藏空白的cell样式
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (id)initWithStyle:(UITableViewStyle)style
{
//    隐藏空白的cell样式
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    return [super initWithStyle:UITableViewStyleGrouped];
}

-(NSArray *)data
{
    if (nil == _data) {
        _data = [NSMutableArray array];
    }
    return _data;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    WuUserGroup *group = self.data[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    WuUserTableViewCell *cell = [WuUserTableViewCell cellWithTableView:tableView];
    
    // 2.给cell传递模型数据
    WuUserGroup *group = self.data[indexPath.section];
    cell.item = group.items[indexPath.row];
    
    // 3.返回cell
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.取消选中这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 2.模型数据
    WuUserGroup *group = self.data[indexPath.section];
    WuUserItems *item = group.items[indexPath.row];

    if (item.option) { // block有值(点击这个cell,.有特定的操作需要执行)
        item.option();
    } else if ([item isKindOfClass:[WuUserArrowItem class]]) { // 箭头
        WuUserArrowItem *arrowItem = (WuUserArrowItem *)item;
        
        // 如果没有需要跳转的控制器
        if (arrowItem.destVclass == nil) return;
        
        UIViewController *vc = [[arrowItem.destVclass alloc] init];
        vc.title = arrowItem.title;
        [self.navigationController pushViewController:vc  animated:YES];
    }
}

//  头部标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    WuUserGroup *group = self.data[section];
    return group.header;
}

//  尾部标题
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    WuUserGroup *group = self.data[section];
    return group.footer;
}

@end
