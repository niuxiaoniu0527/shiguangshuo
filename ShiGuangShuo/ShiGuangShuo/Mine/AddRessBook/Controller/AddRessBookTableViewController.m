//
//  AddRessBookTableViewController.m
//  ShiGuangShuo
//
//  Created by 常超 on 3/23/16.
//  Copyright © 2016 Fuli. All rights reserved.
//

#import "AddRessBookTableViewController.h"

@interface AddRessBookTableViewController ()<EMChatManagerDelegate>

//好友列表
@property (nonatomic,strong) NSArray *buddyList;

@end

@implementation AddRessBookTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取好友列表
    self.buddyList = [[EaseMob sharedInstance].chatManager buddyList];
    //设置的代理
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
}

- (IBAction)leftAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    return self.buddyList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cell_id = @"Buddy_ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    EMBuddy *buddy = self.buddyList[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"header.jpg"];
    cell.textLabel.text = buddy.username;
    
    
    return cell;
}

#pragma mark ------chatManager代理
//监听自动登入成功
- (void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error{
    if (!error) { //自动登入成功,此时buddyList就有值了
        self.buddyList = [[EaseMob sharedInstance].chatManager buddyList];
        [self.tableView reloadData];
    }
}

//好友添加请求同意
- (void)didAcceptedByBuddy:(NSString *)username{
    //把最新添加的好友显示到tablview上
    [self loadBuddyListFromServer];
}
//从服务器获取好友列表
- (void)loadBuddyListFromServer{
    __weak typeof(self) weakSelf = self;
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        weakSelf.buddyList = buddyList;
        [weakSelf.tableView reloadData];
    } onQueue:nil];
}
//好友列表被更新
- (void)didUpdateBuddyList:(NSArray *)buddyList changedBuddies:(NSArray *)changedBuddies isAdd:(BOOL)isAdd{
    //重新赋值
    self.buddyList = buddyList;
    [self.tableView reloadData];
}

#pragma mark ---------监听被好友删除
- (void)didRemovedByBuddy:(NSString *)username{
    //从服务器上重新获取数据,刷新表格
    [self loadBuddyListFromServer];
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




#pragma mark --------tableView表格的删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //获取好友的名字
    EMBuddy *buddy = self.buddyList[indexPath.row];
    NSString *buddyName = buddy.username;
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[EaseMob sharedInstance].chatManager removeBuddy:buddyName removeFromRemote:YES error:nil];
    }
}


@end
