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
#import "UIImageView+WebCache.h"

@interface ChatCell()

@property (nonatomic,strong) UIImageView *chatImageView;

@end


@implementation ChatCell


- (UIImageView *)chatImageView{
    if (!_chatImageView) {
        _chatImageView = [[UIImageView alloc] init];
    }
    return _chatImageView;
}

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
    //重用时把图片移除
    [self.chatImageView removeFromSuperview];
    _message = message;
    //1. 获取消息体
    id body = message.messageBodies[0];
    //判断是否是文本类型
    if ([body isKindOfClass:[EMTextMessageBody class]]) {
        EMTextMessageBody *textBody = body;
        self.messageLabel.text = textBody.text;
    }else if ([body isKindOfClass:[EMVoiceMessageBody class]]){
        self.messageLabel.attributedText = [self Voice];
    }else if ([body isKindOfClass:[EMImageMessageBody class]]) {
        [self showImage];
        
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

#pragma mark --------
- (void)showImage{
    EMImageMessageBody *imgBody = self.message.messageBodies[0];
    CGRect thumbnailSize = (CGRect){0,0,imgBody.thumbnailSize};
    //设置label的尺寸足够显示ImageView
    NSTextAttachment *imgAttac = [[NSTextAttachment alloc] init];
    imgAttac.bounds = thumbnailSize;
    NSAttributedString *imgAtt = [NSAttributedString attributedStringWithAttachment:imgAttac];
    self.messageLabel.attributedText = imgAtt;
    //1.cell里面添加个图片
    [self.messageLabel addSubview:self.chatImageView];
    //2.设置图片控件为缩略图的尺寸
    //获取消息体
    self.chatImageView.frame = thumbnailSize;
    
    //判断本地图片存不存在
    NSFileManager *manager = [NSFileManager defaultManager];
    //占位
    UIImage *placeImg = [UIImage imageNamed:@"downloads.png"];
    if ([manager fileExistsAtPath:imgBody.thumbnailLocalPath]) {
        [self.chatImageView sd_setImageWithURL:[NSURL fileURLWithPath:imgBody.thumbnailLocalPath] placeholderImage:placeImg];
    }else{
        //如果不存在需要加载图片
        [self.chatImageView sd_setImageWithURL:[NSURL URLWithString:imgBody.thumbnailRemotePath] placeholderImage:placeImg];
    }

    
    
}
//返回cell的高度
- (CGFloat)cellHeight{
    //重新布局子控件
    [self layoutIfNeeded];
    return 5 + 10 + self.messageLabel.bounds.size.height + 10 + 5;
}

@end
