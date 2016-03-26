//
//  AudioPlayTool.m
//  ShiGuangShuo
//
//  Created by 常超 on 3/25/16.
//  Copyright © 2016 Fuli. All rights reserved.
//

#import "AudioPlayTool.h"
#import "EMCDDeviceManager.h"

static UIImageView *animationImageView;//正在执行动画的imageView

@implementation AudioPlayTool

+ (void)playWithMessage:(EMMessage *)message messageLable:(UILabel *)messageLable receiver:(BOOL)receiver{
    //把以前的动画移除
    [animationImageView stopAnimating];
    [animationImageView removeFromSuperview];
    //播放语音
    EMVoiceMessageBody *body = message.messageBodies[0];
    NSString *path = body.localPath;
    //如果本地语音不存在,需要用服务器的语音
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) {
        path = body.remotePath;
    }
    //播放语音
    //获取消息体
    [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:path completion:^(NSError *error) {
        //发送语音成功
        //移除动画
        [animationImageView stopAnimating];
        [animationImageView removeFromSuperview];
    }];
    
    //添加动画
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, 30, 30);
    [messageLable addSubview:imageView];
    //添加动画的图片
    if (receiver) {
        imageView.frame = CGRectMake(0, 0, 30, 30);
        imageView.animationImages = @[[UIImage imageNamed:@"chat_receiver_audio_playing000@2x.png"],[UIImage imageNamed:@"chat_receiver_audio_playing001@2x.png"],[UIImage imageNamed:@"chat_receiver_audio_playing002@2x.png"],[UIImage imageNamed:@"chat_receiver_audio_playing003@2x.png"]];
    }else{
        imageView.frame = CGRectMake(messageLable.bounds.size.width - 30, 0, 30, 30);
        imageView.animationImages = @[[UIImage imageNamed:@"chat_sender_audio_playing_000@2x.png"],[UIImage imageNamed:@"chat_sender_audio_playing_001@2x.png"],[UIImage imageNamed:@"chat_sender_audio_playing_002@2x.png"],[UIImage imageNamed:@"chat_sender_audio_playing_003@2x.png"]];
    }
    
    
    imageView.animationDuration = 1;
    [imageView startAnimating];
    animationImageView = imageView;
}

//停止播放语音
+ (void)stop{
    [[EMCDDeviceManager sharedInstance] stopPlaying];
    [animationImageView stopAnimating];
    [animationImageView removeFromSuperview];
}

@end
