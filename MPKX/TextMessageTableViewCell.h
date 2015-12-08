//
//  TextMessageTableViewCell.h
//  LeanMessageDemo
//
//  Created by WuJun on 8/25/15.
//  Copyright (c) 2015 LeanCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <AVOSCloudIM.h>
#import <AVOSCloudIM/AVOSCloudIM.h>

@interface TextMessageTableViewCell : UITableViewCell
@property (strong,nonatomic) AVIMTextMessage *textMessage;
+ (instancetype)cellWithTableView:(UITableView *)tableView isMe:(BOOL)isMe;
@end
