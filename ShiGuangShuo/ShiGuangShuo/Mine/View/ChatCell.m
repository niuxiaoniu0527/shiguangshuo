//
//  ChatCell.m
//  ShiGuangShuo
//
//  Created by 常超 on 3/24/16.
//  Copyright © 2016 Fuli. All rights reserved.
//

#import "ChatCell.h"
#import "EMCDDeviceManager.h"
#import "AudioPlayTool.h"
@implementation ChatCell

- (void)awakeFromNib{
    //在此方法做一些初始
    //给lable添加手势
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messageLabelTap:)];
    [self.messageLabel addGestureRecognizer:tapGR];
}
#pragma mark ----------点击事件
- (void)messageLabelTap:(UITapGestureRecognizer *)sender{
    //只有语音的消息体才能播放语音
    id body = self.message.messageBodies[0];
    if ([body isKindOfClass:[EMVoiceMessageBody class]]) {
        BOOL reciver = [self.reuseIdentifier isEqualToString:ReceiverID];
        [AudioPlayTool playWithMessage:self.message messageLable:self.messageLabel receiver:reciver];
    }
}


- (void)setMessage:(EMMessage *)message{
    _message = message;
    //1. 获取消息体
    id body = message.messageBodies[0];
    //判断是否是文本类型
    if ([body isKindOfClass:[EMTextMessageBody class]]) {
        EMTextMessageBody *textBody = body;
        self.messageLabel.text = textBody.text;
    }else if ([body isKindOfClass:[EMVoiceMessageBody class]]){
        self.messageLabel.attributedText = [self Voice];
    }else{
        self.messageLabel.text = @"未知类型";
    }
}


#pragma mark --------------语音的副文本
- (NSAttributedString *)Voice{
    //创建一个副文本
    NSMutableAttributedString *VoiceAttM = [[NSMutableAttributedString alloc] init];
    if ([self.reuseIdentifier isEqualToString:ReceiverID]) {
        //接收方
        //接收方的副文本 = 图片 + 时间
        //图片
        UIImage *image = [UIImage imageNamed:@"chat_receiver_audio_playing_full@2x.png"];
        //创建一个图片的附件
        NSTextAttachment *imageAttachment = [[NSTextAttachment alloc] init];
        imageAttachment.image = image;
        imageAttachment.bounds = CGRectMake(0, -7, 30, 30);
        //创建一个图片的副文本
        NSAttributedString *imgAtt = [NSAttributedString attributedStringWithAttachment:imageAttachment];
        [VoiceAttM appendAttributedString:imgAtt];
        
        //获取时间duration
        EMVoiceMessageBody *voiceBody = self.message.messageBodies[0];
        NSInteger duration = voiceBody.duration;
        NSString *time = [NSString stringWithFormat:@"%ld '",duration];
        //创建时间副文
        NSAttributedString *timeAtt = [[NSAttributedString alloc] initWithString:time];
        //self.messageLabel.frame.size.width =
        [VoiceAttM appendAttributedString:timeAtt];
        
    }else{
        //发送方
    //发送方的副文本 = 时间 + 图片
        //图片
        
        //获取时间duration
        EMVoiceMessageBody *voiceBody = self.message.messageBodies[0];
        NSInteger duration = voiceBody.duration;
        NSString *time = [NSString stringWithFormat:@"%ld '",duration];
        //创建时间副文
        NSAttributedString *timeAtt = [[NSAttributedString alloc] initWithString:time];
        //self.messageLabel.frame.size.width =
        [VoiceAttM appendAttributedString:timeAtt];
        
        UIImage *image = [UIImage imageNamed:@"chat_sender_audio_playing_full@2x.png"];
        //创建一个图片的附件
        NSTextAttachment *imageAttachment = [[NSTextAttachment alloc] init];
        imageAttachment.image = image;
        imageAttachment.bounds = CGRectMake(0, -7, 30, 30);
        //创建一个图片的副文本
        NSAttributedString *imgAtt = [NSAttributedString attributedStringWithAttachment:imageAttachment];
        [VoiceAttM appendAttributedString:imgAtt];

    }
    return [VoiceAttM copy];

}



//返回cell的高度
- (CGFloat)cellHeight{
    //重新布局子控件
    [self layoutIfNeeded];
    return 5 + 10 + self.messageLabel.bounds.size.height + 10 + 5;
}

@end
