//
//  AddFriendViewTableViewController.m
//  ShiGuangShuo
//
//  Created by 常超 on 3/23/16.
//  Copyright © 2016 Fuli. All rights reserved.
//

#import "AddFriendViewTableViewController.h"
#import "AddFriendHeadView.h"
#import "AddFriendTableViewCell.h"
@interface AddFriendViewTableViewController ()<EMChatManagerDelegate>

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) AddFriendHeadView *addFriendHeadView;

@end

@implementation AddFriendViewTableViewController

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addFriendHeadView = [[AddFriendHeadView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 70)];
    self.tableView.tableHeaderView = self.addFriendHeadView;
    //监听添加好友
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addRessBookCell_id"];
    if (!cell) {
        cell = [[AddFriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addRessBookCell_id"];
    }
    cell.userName.text = self.dataSource[indexPath.row];
    [cell.addBtn addTarget:self action:@selector(addFriendAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark ----------- 搜索事件
- (IBAction)searchAction:(id)sender {
    
    [self.addFriendHeadView.textField resignFirstResponder];
    if(self.addFriendHeadView.textField.text.length > 0)
    {

        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
        if ([self.addFriendHeadView.textField.text isEqualToString:loginUsername]) {
            [self Alert:@"不能添加自己为好友"];
            return;
        }
        
        [self.dataSource removeAllObjects];
        [self.dataSource addObject:self.addFriendHeadView.textField.text];
        [self.tableView reloadData];
    }

    
}

#pragma mark -------- 点击添加好友按钮事件
- (void)addFriendAction:(UIButton *)sender{
    //获取添加好友的名字
    NSString *userName = self.addFriendHeadView.textField.text;
    //向服务器发送添加好友的请求
    //message请求添加好友的 额外信息
    NSString *loginUserName = [[EaseMob sharedInstance].chatManager loginInfo][@"username"];
    NSString *message = [@"我是" stringByAppendingString:loginUserName];
    
    EMError *error = nil;
    [[EaseMob sharedInstance].chatManager addBuddy:userName message:message  error:&error];
    
    if (error) {
        [self Alert:@"添加好友失败,请重新输入"];
    }else{
        [self Alert:@"添加好友已发送"];
    }
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

//提示框
- (void)Alert:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark --------移除聊天管理器
- (void)dealloc{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}
@end
