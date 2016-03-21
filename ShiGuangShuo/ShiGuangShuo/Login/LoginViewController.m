//
//  LoginViewController.m
//  ShiGuangShuo
//
//  Created by 付莉 on 16/3/18.
//  Copyright © 2016年 Fuli. All rights reserved.
//

#import "LoginViewController.h"
#import "PublicViewController.h"
#import "UIImage+ImageEffects.h"

@interface LoginViewController ()
///背景图片
@property (weak, nonatomic) IBOutlet UIImageView *bgImageV;
///用户名
@property (weak, nonatomic) IBOutlet UITextField *userText;
///密码
@property (weak, nonatomic) IBOutlet UITextField *passWordText;
///用户名前边的图片
@property (weak, nonatomic) IBOutlet UIImageView *user;
///用户头像
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
///登陆按钮
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
//立即注册按钮
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
///登陆遇到问题
@property (weak, nonatomic) IBOutlet UILabel *problemLabel;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //得到模糊图片
    UIImage *blurImage = [self.bgImageV.image blurImageWithRadius:18];
    self.bgImageV.image = blurImage;
    //设置楷体
    self.userText.font = [UIFont fontWithName:@"Kaiti" size:18];
    self.passWordText.font = [UIFont fontWithName:@"kaiti" size:18];
    //添加下划线
    [self drawRect:CGRectMake(self.user.frame.origin.x, self.userText.frame.origin.y + 15, kScreenWidth - 80, 1)];
    [self drawRect:CGRectMake(self.user.frame.origin.x, self.passWordText.frame.origin.y + 15, kScreenWidth - 80, 1)];
    self.loginButton.titleLabel.font = [UIFont fontWithName:@"Kaiti" size:18];
    self.registerButton.titleLabel.font = [UIFont fontWithName:@"Kaiti" size:13];
    self.problemLabel.font = [UIFont fontWithName:@"Kaiti" size:13];
    NSLog(@"%f",self.userText.frame.size.height);
    
}

- (void)drawRect:(CGRect)rect{
    UIView *vv = [[UIView alloc] initWithFrame:rect];
    vv.backgroundColor = [UIColor blackColor];
    [self.bgImageV addSubview:vv];
    
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
