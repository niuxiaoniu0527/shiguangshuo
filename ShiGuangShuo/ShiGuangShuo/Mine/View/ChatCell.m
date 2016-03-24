//
//  ChatCell.m
//  ShiGuangShuo
//
//  Created by 常超 on 3/24/16.
//  Copyright © 2016 Fuli. All rights reserved.
//

#import "ChatCell.h"

@implementation ChatCell

- (void)setMessage:(EMMessage *)message{
    _message = message;
    //1. 获取消息体
    id body = message.messageBodies[0];
    //判断是否是文本类型
    if ([body isKindOfClass:[EMTextMessageBody class]]) {
        EMTextMessageBody *textBody = body;
        self.messageLabel.text = textBody.text;
    }else if ([body isKindOfClass:[EMVoiceMessageBody class]]){
        self.messageLabel.text = @"语音";
    }else{
        self.messageLabel.text = @"未知类型";
    }

    
}

//返回cell的高度
- (CGFloat)cellHeight{
    //重新布局子控件
    [self layoutIfNeeded];
    return 5 + 10 + self.messageLabel.bounds.size.height + 10 + 5;
}
@end
