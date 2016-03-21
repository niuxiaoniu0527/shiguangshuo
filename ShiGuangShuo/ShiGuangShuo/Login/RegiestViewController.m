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

@interface RegiestViewController ()
///背景图
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;


@end

@implementation RegiestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //得到模糊图片
    UIImage *blurImage = [self.bgImage.image blurImageWithRadius:13];
    self.bgImage.image = blurImage;

    
    
}

- (IBAction)cancelButton:(UIButton *)sender {
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self dismissViewControllerAnimated:loginVC completion:nil];
    
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
