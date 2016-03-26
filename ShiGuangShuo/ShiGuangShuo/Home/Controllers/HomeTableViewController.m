//
//  HomeTableViewController.m
//  ShiGuangShuo
//
//  Created by 付莉 on 16/3/18.
//  Copyright © 2016年 Fuli. All rights reserved.
//

#import "HomeTableViewController.h"
#import "NoInternetHeadView.h"
#import "SharedHandler.h"

@interface HomeTableViewController ()<EMChatManagerDelegate>

@property (nonatomic,strong) NoInternetHeadView *noInternetView;
//判断有网没网的bool值
@property (nonatomic,assign) BOOL isConnect;

//LeanCloud
@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic,strong)UIImageView *myImageView;
@property(nonatomic,strong)AVObject *thisObj;

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
    
    //DYK添加
    self.title = @"首页";
    
    //注册一下cell
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
    
    //查询组织数据源
    [self queryDataSource];
    
    //下拉刷新
    if(self.tableView.mj_header.hidden == YES){
        self.tableView.mj_header.hidden = NO;
    }
    
        __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
          [weakSelf queryDataSource];
        //隐藏下拉刷新
//        weakSelf.tableView.mj_header.hidden = YES;
    }];
    
    //刷新状态页面
    [SharedHandler SharedHandler].reloadStatusBlock = ^{
        [weakSelf queryDataSource];
    };
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
    AVObject *obj = self.dataSource[indexPath.row];
    
    static NSString *cell_id = @"CustomCell";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if(!cell){
        cell = [[CustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }
    
    cell.nameLbl.text = obj[@"name"];
    
    NSDate *createdDate = obj[@"createdAt"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:createdDate];
    NSString *timeString = [NSString stringWithFormat:@"%@",dateString];
    cell.addDateLbl.text = [NSString stringWithFormat:@"%@",timeString];
    cell.contentLbl.text = obj[@"statusContent"];
    
    [cell.statusImageView sd_setImageWithURL:[NSURL URLWithString:obj[@"imageUrl"]] completed:nil];
    //打开UIImageView的交互
    cell.statusImageView.userInteractionEnabled = YES;
    //给UIImageView添加手势
    UITapGestureRecognizer *tagGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagGrAction:)];
    [cell.statusImageView addGestureRecognizer:tagGr];
    
#pragma mark=======点赞按钮信息
    //从数据库取出当前一条状态的点赞数目 赋给当前button的显示title
    AVQuery *query = [AVQuery queryWithClassName:@"StatusClass"];
    __block NSInteger praiseCount = 0;
    [query getObjectInBackgroundWithId:obj[@"objectId"] block:^(AVObject *object, NSError *error) {
        //点赞按钮
        praiseCount = [[object objectForKey:@"praiseCount"]integerValue];
        [cell.praiseBtn setTitle:[NSString stringWithFormat:@"赞%ld",praiseCount] forState:UIControlStateNormal];
        
        cell.praiseBtn.tag = indexPath.row;
        [cell.praiseBtn addTarget:self action:@selector(praiseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }];
    
#pragma mark=======评论按钮信息
    //评论按钮
    [cell.commentBtn addTarget:self action:@selector(commentBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    AVObject *currentObj = self.dataSource[indexPath.row];
    NSString *currentObjId = currentObj[@"objectId"];
    //给评论按钮赋值
    [self loadCommentBtnInfo:currentObjId button:cell.commentBtn];
    cell.commentBtn.tag = indexPath.row;
    
#pragma mark=======删除按钮信息
    if([obj[@"name"] isEqualToString:@"dyk"]){
        //如果当前状态是当前用户发表的就显示一个删除按钮
        cell.deleBtn.hidden = NO;
        [cell.deleBtn addTarget:self action:@selector(deleStatusAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.deleBtn.tag = indexPath.row;
    }
    else{
        cell.deleBtn.hidden = YES;
    }
    return cell;
}
//每一个单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300;
}
//图片的轻拍手势执行的方法
- (void)tagGrAction:(UITapGestureRecognizer *)sender{
    
    ShowBigImageVC *bigImage = [[ShowBigImageVC alloc]init];
    bigImage.myImage = ((UIImageView *)sender.view).image;
    
    UINavigationController *bigImageNC = [[UINavigationController alloc]initWithRootViewController:bigImage];
    
    //翻页效果
    [bigImageNC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentViewController:bigImageNC animated:YES completion:nil];
}
//点赞
- (void)praiseBtnAction:(UIButton *)sender{
    
    //从数据库取出当前的点赞数
    AVObject *currentObj = self.dataSource[sender.tag];
    NSInteger currentPraiseCount = [currentObj[@"praiseCount"] integerValue];
    currentPraiseCount +=1;
    
    [sender setTitle:[NSString stringWithFormat:@"赞%ld",currentPraiseCount] forState:UIControlStateNormal];
    [currentObj setObject:[NSString stringWithFormat:@"%ld",currentPraiseCount] forKey:@"praiseCount"];
    
    [currentObj save];
    
    [self.tableView reloadData];
}
//评论
- (void)commentBtnAction:(UIButton *)sender{
    //取到当前操作的cell的AVObject对象
    AVObject *currentObj = self.dataSource[sender.tag];
    NSString *currentObjId = currentObj[@"objectId"];
    
    CommentVC *commentVC = [[CommentVC alloc]init];
    commentVC.currentStatusId = currentObjId;
    
    //用于刷新当前按钮的标题值
    commentVC.reloadCommentBlock = ^{
        [self loadCommentBtnInfo:currentObjId button:sender];
    };
    [self.navigationController pushViewController:commentVC animated:YES];
}
//加载评论个数
- (void)loadCommentBtnInfo:(NSString *)currentObjId button:(UIButton *)button{
    //根据数据库查询当前的评论个数
    NSString *cqlStr = [NSString stringWithFormat:@"select commentArr from %@ where currentStatusId = '%@' order by updatedAt desc",@"TestDic",currentObjId];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0), ^{
        [AVQuery doCloudQueryInBackgroundWithCQL:cqlStr callback:^(AVCloudQueryResult *result, NSError *error) {
            AVObject *thisObj = nil;
            if(0 != result.results.count)
            {
                thisObj = result.results[0];
            }
            NSMutableArray *arr = thisObj[@"commentArr"];
            
            [button setTitle:[NSString stringWithFormat:@"评论%ld",arr.count] forState:UIControlStateNormal];
        }];
    });
}
//删除动态信息
- (void)deleStatusAction:(UIButton *)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定要删除该动态吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertController *showAlert =[UIAlertController alertControllerWithTitle:@"提示" message:@"删除中..." preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //删除数据库的动态信息和评论信息
        [weakSelf showDetailViewController:showAlert sender:nil];
        
        //取到当前操作的cell的AVObject对象
        AVObject *currentObj = self.dataSource[sender.tag];
        NSString *currentObjId = currentObj[@"objectId"];
        NSString *deleStatusCql = [NSString stringWithFormat:@"delete from %@ where objectId = '%@'",@"StatusClass",currentObjId];
        NSString *getDeleStatusCommentArrCql = [NSString stringWithFormat:@"select * from %@ where currentStatusId = '%@'",@"TestDic",currentObjId];
        
        [AVQuery doCloudQueryInBackgroundWithCQL:deleStatusCql callback:^(AVCloudQueryResult *result, NSError *error) {
            [AVQuery doCloudQueryInBackgroundWithCQL:getDeleStatusCommentArrCql callback:^(AVCloudQueryResult *result, NSError *error) {
                if(nil != result.results){
                    [AVObject deleteAllInBackground:result.results block:nil];
                }
                [weakSelf queryDataSource];
                [weakSelf.tableView reloadData];
                [weakSelf dismissViewControllerAnimated:showAlert completion:nil];
            }];
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:sureAction];
    [alert addAction:cancelAction];
    [self showDetailViewController:alert sender:nil];
}
#pragma mark====DYK添加 LeanCloud
- (void)queryDataSource{
    //组织数据源
    
    __block typeof(self) weakSelf = self;
    NSString *cqlStr = [NSString stringWithFormat:@"select * from %@ order by createdAt desc",@"StatusClass"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [AVQuery doCloudQueryInBackgroundWithCQL:cqlStr callback:^(AVCloudQueryResult *result, NSError *error) {
            weakSelf.dataSource = result.results;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }];
    });
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
