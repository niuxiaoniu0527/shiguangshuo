//
//  CommentVC.m
//  LeanCloudTest
//
//  Created by DYK on 16/3/18.
//  Copyright © 2016年 DYK. All rights reserved.
//

#import "CommentVC.h"

@interface CommentVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation CommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论页面";
    
    [self.commitBtn addTarget:self action:@selector(commitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.statusListTableView.dataSource = self;
    self.statusListTableView.delegate = self;
    
    //注册自定义的cell
    [self.statusListTableView registerNib:[UINib nibWithNibName:@"CustomCommentCell" bundle:nil] forCellReuseIdentifier:@"cell_id"];
    
    //一进来就加载数据源
    NSString *cqlStr = [NSString stringWithFormat:@"select commentArr from %@ where currentStatusId = '%@' order by updatedAt desc",@"TestDic",self.currentStatusId];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [AVQuery doCloudQueryInBackgroundWithCQL:cqlStr callback:^(AVCloudQueryResult *result, NSError *error) {
            AVObject *thisObj = nil;
            if(0 != result.results.count)
            {
                thisObj = result.results[0];
            }
            NSMutableArray *arr = thisObj[@"commentArr"];
            
            weakSelf.dataSource = arr;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.statusListTableView reloadData];
            });
        }];
    });
}

//提交
- (void)commitBtnAction:(UIButton *)sender{
    //提示
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"提交中，请稍候..." preferredStyle:UIAlertControllerStyleAlert];
    [self showDetailViewController:alert sender:nil];

    AVObject *TestDic = [AVObject objectWithClassName:@"TestDic"];
    
    //获取当前的系统时间
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    NSDictionary *currentCommentDic = [NSDictionary dictionaryWithObjectsAndKeys:@"dyk",@"reviewer",dateString,@"reviewTime",self.commentTextView.text,@"reviewContent",nil];
    
    //NSMutableArray *arr = TestDic[@"commentArr"];
    //首先从TestDic查找commentArr字段是否有值
    
    
    NSString *cqlStr = [NSString stringWithFormat:@"select commentArr from %@ where currentStatusId = '%@' order by updatedAt desc",@"TestDic",self.currentStatusId];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        [AVQuery doCloudQueryInBackgroundWithCQL:cqlStr callback:^(AVCloudQueryResult *result, NSError *error) {
            AVObject *thisObj = nil;
            if(0 != result.results.count)
            {
                thisObj = result.results[0];
            }
            
            NSMutableArray *arr = thisObj[@"commentArr"];
            //如果没有取到当前的数组属性就先新建一个数组属性值
            if(nil == arr){
                [TestDic setObject:self.currentStatusId forKey:@"currentStatusId"];
                arr = [NSMutableArray new];
                [arr addObject:currentCommentDic];
                [TestDic setObject:arr forKey:@"commentArr"];
                [TestDic saveInBackground];
            }
            else{
                [TestDic setObject:self.currentStatusId forKey:@"currentStatusId"];
                [arr addObject:currentCommentDic];
                [TestDic setObject:arr forKey:@"commentArr"];
                [TestDic saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if(succeeded){
                        [TestDic setObject:arr forKey:@"commentArr"];
                        [TestDic saveInBackground];
                    }
                }];
            }
            
            self.dataSource = arr;
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.statusListTableView reloadData];
                weakSelf.reloadCommentBlock();//刷新评论按钮的值
                [weakSelf dismissViewControllerAnimated:alert completion:nil];
            });
        }];
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell_id = @"cell_id";
    
    CustomCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id forIndexPath:indexPath];
    if(!cell){
        cell = [[CustomCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }
    NSDictionary *dic = self.dataSource[indexPath.row];
    cell.reviewerLbl.text = dic[@"reviewer"];
    cell.timeLbl.text = dic[@"reviewTime"];
    cell.commentLbl.text = dic[@"reviewContent"];
    
    //如果当前评论是当前用户写的就显示删除按钮
    if([dic[@"reviewer"] isEqualToString:@"dyk"]){
        cell.deleteBtn.hidden = NO;
        [cell.deleteBtn addTarget:self action:@selector(deleteCommentAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.deleteBtn.tag = indexPath.row;
    }
    else{
        cell.deleteBtn.hidden = YES;
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
//删除当前的评论内容
- (void)deleteCommentAction:(UIButton *)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"删除中..." preferredStyle:UIAlertControllerStyleAlert];
    [self showDetailViewController:alert sender:nil];
    
    NSDictionary *dic = self.dataSource[sender.tag];
    //从数据库中取出当前的评论数组
    NSString *cqlStr = [NSString stringWithFormat:@"select commentArr from %@ where currentStatusId = '%@' order by updatedAt desc",@"TestDic",self.currentStatusId];
    [AVQuery doCloudQueryInBackgroundWithCQL:cqlStr callback:^(AVCloudQueryResult *result, NSError *error) {
        AVObject *thisObj = nil;
        if(0 != result.results.count)
        {
            thisObj = result.results[0];
        }
        NSMutableArray *arr = thisObj[@"commentArr"];
        [arr removeObject:dic];
        
        [thisObj setObject:self.currentStatusId forKey:@"currentStatusId"];
        [thisObj setObject:arr forKey:@"commentArr"];
        [thisObj saveInBackgroundWithBlock:nil];
        
        self.dataSource = arr;
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.statusListTableView reloadData];
            weakSelf.reloadCommentBlock();//刷新评论按钮的值
            [weakSelf dismissViewControllerAnimated:alert completion:nil];
        });
    }];
}
@end
