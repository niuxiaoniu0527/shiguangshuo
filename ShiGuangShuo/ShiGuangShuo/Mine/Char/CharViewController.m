//
//  CharViewController.m
//  ShiGuangShuo
//
//  Created by 常超 on 3/24/16.
//  Copyright © 2016 Fuli. All rights reserved.
//

#import "CharViewController.h"

@interface CharViewController ()

//聊天输入框底部的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *charBottomConstraint;

@end

@implementation CharViewController


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //监听键盘的弹出 输入工具条上移
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //监听键盘的推出 输入框恢复到原位
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -------键盘显示会触发的方法
- (void)kbWillShow:(NSNotification *)noti{
    //获取键盘的高度
    //获取键盘结束时候的位置
    CGRect kbEndFram = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kbHeight = kbEndFram.size.height;
    //更改inputViewBottomConstraint约束
    self.charBottomConstraint.constant = kbHeight;
    //添加动画
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}
#pragma mark ------键盘隐藏时候会触发的方法
- (void)kbWillHide:(NSNotification *)noti{
    self.charBottomConstraint.constant = 0;
}




@end
