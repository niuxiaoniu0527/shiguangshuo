//
//  RegiestViewController.m
//  ShiGuangShuo
//
//  Created by 付莉 on 16/3/21.
//  Copyright © 2016年 Fuli. All rights reserved.
//

#import "RegiestViewController.h"
#import "UIImage+ImageEffects.h"
#import "LoginViewController.h"
#import "NSString+Valid.h"
@interface RegiestViewController ()
///背景图
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
//用户名
@property (weak, nonatomic) IBOutlet UITextField *userName;
//输入密码
@property (weak, nonatomic) IBOutlet UITextField *password;
//再次输入密码
@property (weak, nonatomic) IBOutlet UITextField *againPassword;


@end

@implementation RegiestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //得到模糊图片
    UIImage *blurImage = [self.bgImage.image blurImageWithRadius:13];
    self.bgImage.image = blurImage;
    
    //输入密码为密文格式
    self.password.secureTextEntry = YES;
    self.againPassword.secureTextEntry = YES;
    
}

- (IBAction)cancelButton:(UIButton *)sender {
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self dismissViewControllerAnimated:loginVC completion:nil];
    
}

- (IBAction)regiestAction:(id)sender {
    
    //获取用户名
    NSString *userName = self.userName.text;
    //获取密码
    NSString *passWord = self.password.text;
    //获取第二次输入密码
    NSString *againPassword = self.againPassword.text;

    //判断用户名密码为不为空
    if (userName.length == 0 || passWord.length == 0) {
        [self Alert:[NSString stringWithFormat:@"用户名密码不能为空"]];
        
        return;
    }

    if (![passWord isEqualToString:againPassword]) {
        [self Alert:[NSString stringWithFormat:@"两次输入密码不符"]];
        
        return;
    }
    
    //注册
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:userName password:passWord withCompletion:^(NSString *username, NSString *password, EMError *error) {
        if (!error) {
            UIAlertController  *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"注册成功" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];

            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self dismissViewControllerAnimated:alert completion:nil];
                LoginViewController *loginVC = [[LoginViewController alloc] init];
                [self dismissViewControllerAnimated:loginVC completion:nil];

                
            });
            
            

        }else{
            [self Alert:[NSString stringWithFormat:@"注册失败 %@",error]];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
