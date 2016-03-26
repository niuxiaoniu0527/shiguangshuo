//
//  CharViewController.m
//  ShiGuangShuo
//
//  Created by 常超 on 3/24/16.
//  Copyright © 2016 Fuli. All rights reserved.
//

#import "CharViewController.h"
#import "EMCDDeviceManager.h"
#import "ChatCell.h"
#import "AudioPlayTool.h"
#import "TiemCell.h"
#import "TimeTool.h"

@interface CharViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,EMChatManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

//聊天输入框底部的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *charBottomConstraint;
//数据源
@property (nonatomic,strong) NSMutableArray *dataSoure;

//计算高度的cell工具对象
@property (nonatomic,strong) ChatCell *chatCellTool;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//inputToolBar高度的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottom;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;

//当前添加的时间
@property (nonatomic,copy) NSString *currentTime;
@end

@implementation CharViewController


- (NSMutableArray *)dataSoure{
    if (!_dataSoure) {
        _dataSoure = [NSMutableArray array];
    }
    return _dataSoure;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *buddyName = self.buddy.username;
    self.navigationItem.title = [NSString stringWithFormat:@"与%@交谈中...",buddyName];
    self.tableView.backgroundColor = [UIColor colorWithRed:246 / 255.0 green:246 / 255.0 blue:246 / 255.0 alpha:1];
    
    //加载本地数据内容
    [self loadLocalChatMessage];
    
    //计算高度的cell工具对象 赋值
    self.chatCellTool = [self.tableView dequeueReusableCellWithIdentifier:ReceiverID];
    //设置聊天管理器的代理
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    //监听键盘的弹出 输入工具条上移
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //监听键盘的推出 输入框恢复到原位
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //消息滚动到最后一行
    [self scrollToBottom];
}

#pragma mark -------键盘显示会触发的方法
- (void)kbWillShow:(NSNotification *)noti{
    //获取键盘的高度
    //获取键盘结束时候的位置
    CGRect kbEndFram = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kbHeight = kbEndFram.size.height;
    //更改inputViewBottomConstraint约束
    self.charBottomConstraint.constant = kbHeight;
    [self.tableView layoutIfNeeded];
    [self scrollToBottom];
    //添加动画
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}
#pragma mark ------键盘隐藏时候会触发的方法
- (void)kbWillHide:(NSNotification *)noti{
    self.charBottomConstraint.constant = 0;
}

#pragma mark -----tableView数据源


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSoure.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatCell *cell = nil;
    //判断数据源类型
    if ([self.dataSoure[indexPath.row] isKindOfClass:[NSString class]]) {
        TiemCell *timeCell = [tableView dequeueReusableCellWithIdentifier:@"TimeCell"];
        timeCell.timeLabel.text = self.dataSoure[indexPath.row];
        return timeCell;
    }
    
    //1.先获取消息模型
    EMMessage *message = self.dataSoure[indexPath.row];
    if ([message.from isEqualToString:self.buddy.username]) {//接收方
        cell = [tableView dequeueReusableCellWithIdentifier:ReceiverID];
    }else{//发送方
        cell = [tableView dequeueReusableCellWithIdentifier:SendID];
    }
    
    cell.message = message;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //时间的cell高度
    if ([self.dataSoure[indexPath.row] isKindOfClass:[NSString class]]) {
        return 23;
    }
    
    //1.获取消息模型
    EMMessage *message = self.dataSoure[indexPath.row];
    self.chatCellTool.message = message;
    
    return [self.chatCellTool cellHeight];
}

#pragma mark ------- textViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    
    //计算TextView的高度,调整整个输入条的高度
    CGFloat textViewH = 0;
    CGFloat minTextViewH = 33; //textView最小的高度
    CGFloat maxTextViewH = 68; //textView最大的高度
    //获取contentSize的高度
    CGFloat contentHeight = textView.contentSize.height;
    if (contentHeight < minTextViewH) {
        textViewH = minTextViewH;
    }else if (contentHeight > maxTextViewH){
        textViewH = maxTextViewH;
    }else{
        textViewH = contentHeight;
    }
    
    //监听send事件----判断最后一行字符是不是换行
    if ([textView.text hasSuffix:@"\n"]) {
        if([textView.text isEqualToString:@"\n"])
        {
            textView.text = @"";
            return;
        }
        [self sendText:textView.text];
        //清空textView的文字
        textView.text = nil;
        //发送时textView的高度为33
        textViewH = minTextViewH;
    }
    
    //调整inputToolBar高度
    self.inputViewBottomConstraint.constant = 13 + textViewH;
    //添加个动画
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
    //让光标回到原位
    [textView setContentOffset:CGPointZero animated:YES];
    [textView scrollRangeToVisible:textView.selectedRange];
    
}

#pragma mark -----------发送一个文本消息
- (void)sendText:(NSString *)text{
    
    //把最后一个换行字符去除 换行字符只占用一个长度
    text = [text substringToIndex:text.length - 1];
    
    
    //创建一个聊天文本
    EMChatText *chatText = [[EMChatText alloc] initWithText:text];
    //创建文本消息体
    EMTextMessageBody *textBody = [[EMTextMessageBody alloc] initWithChatObject:chatText];
    
    [self sendMessage:textBody];
}

#pragma mark ------------- 发送语音
- (void)sendVoice:(NSString *)recordPath duration:(NSInteger)duration{
    //构造一个语音的消息体
    EMChatVoice *charVoice = [[EMChatVoice alloc] initWithFile:recordPath displayName:@"语音"];
    EMVoiceMessageBody *voiceMsg = [[EMVoiceMessageBody alloc] initWithChatObject:charVoice];
    voiceMsg.duration = duration;
    [self sendMessage:voiceMsg];
    
}

#pragma mark -----------发送图片
- (void)sendImage:(UIImage *)selectedImg{
    //构造图片的消息体
    /*
     第一个参数 原始大小的参数
     第二个参数 缩略图对象
     */
    EMChatImage *orginalImage = [[EMChatImage alloc] initWithUIImage:selectedImg displayName:@"[图片]"];
    
    EMImageMessageBody *imgBody = [[EMImageMessageBody alloc] initWithImage:orginalImage thumbnailImage:nil];
    
    [self sendMessage:imgBody];
}
#pragma mark ------------发送消息体
- (void)sendMessage:(id<IEMMessageBody>)body{
    //构造消息对象
    EMMessage *messageObj = [[EMMessage alloc] initWithReceiver:self.buddy.username bodies:@[body]];
    
    messageObj.messageType = eMessageTypeChat;
    //发送消息
    [[EaseMob sharedInstance].chatManager asyncSendMessage:messageObj progress:nil prepare:^(EMMessage *message, EMError *error) {
        
    } onQueue:nil completion:^(EMMessage *message, EMError *error) {
        NSLog(@"%@",error);
    } onQueue:nil];
    
    //把消息添加到数据源,然后刷新表格
    [self addDataSourceWithMessage:messageObj];
    [self.tableView reloadData];
    //把消息滚动显示到最前面
    [self scrollToBottom];
    
}



//把消息滚动显示到最前面
- (void)scrollToBottom{
    //获取最好一行
    if (self.dataSoure.count == 0) {
        return;
    }
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:self.dataSoure.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark ------------接受好友回复消息
- (void)didReceiveMessage:(EMMessage *)message{
    //经行判断from一定要等于当前聊天用户
    if ([message.from isEqualToString:self.buddy.username]) {
        //把接受消息放进数据源
        [self.dataSoure addObject:message];
        //刷新表格
        [self.tableView reloadData];
        //显示数据到底部
        [self scrollToBottom];
    }
    
}

#pragma mark ---------加载本地数据库
//获取本地数据库
- (void)loadLocalChatMessage{
    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.buddy.username conversationType:eConversationTypeChat];
    
    //加载与当前好友聊天的所有记录
    NSArray *messages = [conversation loadAllMessages];
    for (EMMessage *messageObj in messages) {
        [self addDataSourceWithMessage:messageObj];
    }
    
}

#pragma mark --------- Action
//点击录音btn切换输入框样式
- (IBAction)voiceAction:(UIButton *)sender {
    self.recordBtn.hidden = !self.recordBtn.hidden;
    self.textView.hidden = !self.textView.hidden;
    if (self.recordBtn.hidden == NO) {
        self.inputViewBottomConstraint.constant = 46;
        [self.view endEditing:YES];
    }else{
        //显示键盘
        [self.textView becomeFirstResponder];
        [self textViewDidChange:self.textView];
    }
}
#pragma mark --------------按钮点下去开始录音
- (IBAction)beginRecordAction:(id)sender {
    //文件名以时间命名
    int x = arc4random() % 100000;
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];
    
    [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName completion:^(NSError *error) {
        if (!error) {
            //  NSLog(@"开始录音成功");
        }
    }];
}
#pragma mark --------------手指在按钮范围内抬起结束录音
- (IBAction)endRecordAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        if (!error) {
            // NSLog(@"录音成功");
            //发送语音给服务器
            [weakSelf sendVoice:recordPath duration:aDuration];
        }
    }];
}
#pragma mark --------------手指在按钮的外面取消发送
- (IBAction)cancelRecordAction:(id)sender {
    [[EMCDDeviceManager sharedInstance] cancelCurrentRecording];
}
- (IBAction)showImagePickerAction:(id)sender {
    UIImagePickerController *imagePC = [[UIImagePickerController alloc] init];
    //设置源
    imagePC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //设置代理
    imagePC.delegate = self;
    
    [self presentViewController:imagePC animated:YES completion:nil];
    
}
//用户选中图片的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //获取用户选中的图片
    UIImage *selectedImg = info[UIImagePickerControllerOriginalImage];
    //发送图片
    [self sendImage:selectedImg];
    //隐藏当前图片选中控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ---------开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //停止语音播放
    [AudioPlayTool stop];
}

- (void)addDataSourceWithMessage:(EMMessage *)message{
    //判断EMMessage对象前面用不用加时间
    NSString *timeStr = [TimeTool timeStr:message.timestamp];
    
    if (![self.currentTime isEqualToString:timeStr]) {
        [self.dataSoure addObject:timeStr];
        self.currentTime = timeStr;
    }
    //添加message对象
    [self.dataSoure addObject:message];
    
    //设置消息为已读
  //  [self.conversation markMessageWithId:message.messageId asRead:YES];
}

@end
