//
//  ChatCell.h
//  ShiGuangShuo
//
//  Created by 常超 on 3/24/16.
//  Copyright © 2016 Fuli. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *ReceiverID = @"ReceiverCell";
static NSString *SendID = @"SendCell";
@interface ChatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

//消息模型set方法显示文字
@property(nonatomic,strong) EMMessage *message;

//cell的高度
- (CGFloat)cellHeight;

@end
