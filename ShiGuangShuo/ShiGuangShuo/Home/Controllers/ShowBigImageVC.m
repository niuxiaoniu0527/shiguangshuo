//
//  ShowBigImageVC.m
//  ShiGuangShuo
//
//  Created by DYK on 16/3/25.
//  Copyright © 2016年 Fuli. All rights reserved.
//

#import "ShowBigImageVC.h"

@interface ShowBigImageVC ()

@end

@implementation ShowBigImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 150,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-250)];
    self.myImageView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.myImageView];
    
    self.myImageView.image = self.myImage;
    
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(leftBackItemAction)];
    self.navigationItem.leftBarButtonItem = leftBackItem;
}
- (void)leftBackItemAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
