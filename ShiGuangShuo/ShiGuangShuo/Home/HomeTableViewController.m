//
//  HomeTableViewController.m
//  ShiGuangShuo
//
//  Created by 付莉 on 16/3/18.
//  Copyright © 2016年 Fuli. All rights reserved.
//

#import "HomeTableViewController.h"
#import "NoInternetHeadView.h"
@interface HomeTableViewController ()<EMChatManagerDelegate>

@property (nonatomic,strong) NoInternetHeadView *noInternetView;
//判断有网没网的bool值
@property (nonatomic,assign) BOOL isConnect;
@end

@implementation HomeTableViewController

- (NoInternetHeadView *)noInternetView{
    if (!_noInternetView) {
        _noInternetView = [[NoInternetHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    }
    return _noInternetView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //chatManager设置代理 监听网络状态 和 好友请求
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];

    self.isConnect = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cell_id = @"cell_id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }
    cell.textLabel.text = @"111";
    // Configure the cell...
    
    return cell;
}



//设置头view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0 && self.isConnect == NO) {
        return self.noInternetView;
    }
    return nil;
}


#pragma mark -----------------chatManager代理方法----------------------
//1. 监听网络状态
- (void)didConnectionStateChanged:(EMConnectionState)connectionState{
    // eEMConnectionConnected,   //连接成功
    // eEMConnectionDisconnected,//未连接
    
    if (connectionState == eEMConnectionDisconnected) {
        self.isConnect = NO;
        [self.tableView reloadData];
    }else{
        self.isConnect = YES;
        
        [self.tableView reloadData];
    }
    
}

- (void)willAutoReconnect{
    NSLog(@"将自动重连接");
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error{
    if (!error) {
        //  NSLog(@"自动重连成功");
        [self.tableView reloadData];
    }else{
        NSLog(@"自动重连失败 %@",error);
        [self.tableView reloadData];
    }
}

#pragma mark ----------移除聊天管理器
- (void)dealloc{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}
#pragma mark -------- 好友添加代理方法
//好友请求被同意
- (void)didAcceptedByBuddy:(NSString *)username{
    
    NSString *message = [NSString stringWithFormat:@"%@ 同意了你的好友请求",username];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"好友添加消息" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    
}
//好友请求被拒绝
- (void)didRejectedByBuddy:(NSString *)username{
    NSString *message = [NSString stringWithFormat:@"%@ 拒绝了你的好友请求",username];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"好友添加消息" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    
}
#pragma mark ------------接受好友的添加请求
- (void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"好友添加请求" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"接受" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[EaseMob sharedInstance].chatManager acceptBuddyRequest:username error:nil];
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拒接" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[EaseMob sharedInstance].chatManager rejectBuddyRequest:username reason:nil error:nil];
    }];
    [alert addAction:action];
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

@end
