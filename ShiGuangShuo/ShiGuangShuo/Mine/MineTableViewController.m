//
//  MineTableViewController.m
//  ShiGuangShuo
//
//  Created by 付莉 on 16/3/18.
//  Copyright © 2016年 Fuli. All rights reserved.
//

#import "MineTableViewController.h"
#import "RequestMine.h"
#import "AddRessBookTableViewController.h"
#import "ExitCell.h"

@interface MineTableViewController ()
@property (nonatomic,strong)NSArray *arr;

@end

@implementation MineTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arr = [RequestMine setData];
    //注册退出的cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ExitCell" bundle:nil] forCellReuseIdentifier:@"ExitCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1){
    return self.arr.count;
    }else{
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 || indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            NSString *loginUserName = [[EaseMob sharedInstance].chatManager loginInfo][@"username"];
            cell.textLabel.text = loginUserName;
            cell.imageView.image = [UIImage imageNamed:@"header.jpg"];
            cell.imageView.frame = CGRectMake(10, 10, 100, 100);
        }
        
        if (indexPath.section == 1) {
            
            if (indexPath.row == 0) {
                cell.imageView.image = [UIImage imageNamed:@"message_icon_group"];
                cell.textLabel.text = self.arr[indexPath.row];
                
            }else if (indexPath.row == 1) {
                cell.imageView.image = [UIImage imageNamed:@"album"];
                cell.textLabel.text = self.arr[indexPath.row];
            }
        }
        return cell;

    }else{
        ExitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExitCell" forIndexPath:indexPath];
        return cell;
    }
}
//cell的高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 100;
    }else{
        return 45;
    }
}
//footer高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            UITableViewController *addRessBookTVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"AddRessBookTableViewController"];
            //跳转事件
            [self.navigationController pushViewController:addRessBookTVC animated:YES];
            
        }
    }
#warning ..................................
    if (indexPath.section == 2) {
            NSLog(@"退出登入");
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
