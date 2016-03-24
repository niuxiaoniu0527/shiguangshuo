//
//  MessageTableViewController.m
//  ShiGuangShuo
//
//  Created by 常超 on 3/23/16.
//  Copyright © 2016 Fuli. All rights reserved.
//

#import "MessageTableViewController.h"
#import "NoInternetHeadView.h"
@interface MessageTableViewController ()<EMChatManagerDelegate>

@property (nonatomic,strong) NoInternetHeadView *noInternetView;
//判断有网没网的bool值
@property (nonatomic,assign) BOOL isConnect;

@end

@implementation MessageTableViewController

- (NoInternetHeadView *)noInternetView{
    if (!_noInternetView) {
        _noInternetView = [[NoInternetHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    }
    return _noInternetView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //chatManager设置代理 监听网络状态
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    self.isConnect = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cell_id = @"cell_id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }
    cell.textLabel.text = @"1111";
    
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


@end
