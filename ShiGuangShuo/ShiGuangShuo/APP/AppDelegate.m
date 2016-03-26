//
//  AppDelegate.m
//  ShiGuangShuo
//
//  Created by 付莉 on 16/3/18.
//  Copyright © 2016年 Fuli. All rights reserved.
//

#import "AppDelegate.h"
#import "PublicViewController.h"
@interface AppDelegate ()<EMChatManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //初始化LeanClound
    [AVOSCloud setApplicationId:@"bEvIqjK4kHMQ2pgCaduXPQUi-gzGzoHsz" clientKey:@"MBgllDQkWMWmRREuKzKJp6EL"];
    
    //registerSDKWithAppKey:注册的appKey，详细见下面注释。
    //apnsCertName:推送证书名(不需要加后缀)，详细见下面注释。
    //1.初始化SDK,并隐藏环信SDK的日志输出
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"cc1314567#timesay" apnsCertName:nil otherConfig:@{kSDKConfigEnableConsoleLogger:@(NO)}];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    //2.监听自动登入的状态
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    return YES;
}



#pragma mark 自动登入的回调
- (void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error{
    if (!error) {
        // NSLog(@"自动登入成功 %@",loginInfo);
        //如果登入过直接来到主界面
        if ([[EaseMob sharedInstance].chatManager isAutoLoginEnabled]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                PublicViewController *publicVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"PublicViewController"];
                self.window.rootViewController = publicVC;
                
            });
    }else{
        NSLog(@"自动登入失败 %@",error);
        }
    }
}
- (void)dealloc{
    //移除聊天管理器的代理
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}


// App进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

// App将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

// 申请处理时间
- (void)applicationWillTerminate:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
#pragma mark -------- 好友添加代理方法
//好友请求被同意
- (void)didAcceptedByBuddy:(NSString *)username{
    
    NSString *message = [NSString stringWithFormat:@"%@ 同意了你的好友请求",username];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"好友添加消息" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    });

    
}
//好友请求被拒绝
- (void)didRejectedByBuddy:(NSString *)username{
    NSString *message = [NSString stringWithFormat:@"%@ 拒绝了你的好友请求",username];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"好友添加消息" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    });

    
    
    
    
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
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    });

    
    
    
    
    
}


@end
