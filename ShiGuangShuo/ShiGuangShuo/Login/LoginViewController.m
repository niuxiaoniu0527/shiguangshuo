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
#import "NSString+Valid.h"
#import "PublicViewController.h"

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
    //NSLog(@"%f",self.userText.frame.size.height);
    
    
}

- (void)drawRect:(CGRect)rect{
    UIView *vv = [[UIView alloc] initWithFrame:rect];
    vv.backgroundColor = [UIColor blackColor];
    [self.bgImageV addSubview:vv];
    
}
#pragma mark ---------登入按钮
- (IBAction)loginAction:(UIButton *)sender {
    //第一次登入自动获取好友列表
    [[EaseMob sharedInstance].chatManager setIsAutoFetchBuddyList:YES];
    //获取用户名
    NSString *userName = self.userText.text;
    //获取密码
    NSString *passWord = self.passWordText.text;
    
    //判断用户名密码为不为空
    if (userName.length == 0 || passWord.length == 0) {
        [self Alert:@"用户名密码为不为空"];
    }
    if ([userName isChinese]) {
        [self Alert:@"用户名不能为中文"];
    }

    //登入
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:userName password:passWord completion:^(NSDictionary *loginInfo, EMError *error) {
        //登入请求完成后block回调
        if (!error) {
            //设置自动登入
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
            
            UIAlertController  *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录成功" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self dismissViewControllerAnimated:alert completion:nil];
                
                UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                PublicViewController *publicVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"PublicViewController"];
                
                //跳转事件
                [self presentViewController:publicVC animated:YES completion:nil];
                
            });
            
        }else{
            [self Alert:[NSString stringWithFormat:@"登录失败:%@",error]];
        }
        
    } onQueue:dispatch_get_main_queue()];

}


//提示框
- (void)Alert:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
