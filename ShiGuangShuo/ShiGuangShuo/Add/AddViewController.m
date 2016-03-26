//
//  AddViewController.m
//  ShiGuangShuo
//
//  Created by 付莉 on 16/3/18.
//  Copyright © 2016年 Fuli. All rights reserved.
//

#import "AddViewController.h"
#import "UIImage+ImageEffects.h"
#import "SharedHandler.h"

@interface AddViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>
@property(nonatomic,strong)UITextView *statusTextView;
@property(nonatomic,strong)UIImageView *statusImageView;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIButton *addImageBtn;
@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发状态";
    
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftBackItemAction:)];
    UIBarButtonItem *rightSubmitItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(rightSubmitItemAction:)];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    self.navigationItem.rightBarButtonItem = rightSubmitItem;
    
    //布局
    UIImage *image = [UIImage imageNamed:@"png.png"];
    UIImage *bImage = [image blurImageWithRadius:1];
    image = bImage;
    self.imageView = [[UIImageView alloc]initWithImage:bImage];
    self.imageView.frame = [[UIScreen mainScreen]bounds];
    [self.view addSubview:self.imageView];
    [self.view sendSubviewToBack:self.imageView];
    
    self.statusTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 75, [UIScreen mainScreen].bounds.size.width, 150)];
    self.statusTextView.text = @"说点什么吧...";
    self.statusTextView.alpha = 0.6;
    [self.statusTextView setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:self.statusTextView];
    
    self.addImageBtn = [[UIButton alloc]initWithFrame:CGRectMake(120, 250, 150, 250)];
    [self.addImageBtn setTitle:@"点我添加图片" forState:UIControlStateNormal];
    [self.addImageBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.view addSubview:self.addImageBtn];
    [self.addImageBtn addTarget:self action:@selector(addImageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)viewDidAppear:(BOOL)animated{
  self.tabBarController.tabBar.hidden = YES;
}
//取消
- (void)leftBackItemAction:(UIBarButtonItem *)sender{
    self.tabBarController.selectedIndex = 0;
    self.tabBarController.tabBar.hidden = NO;
}
//添加图片
- (void)addImageBtnAction:(UIButton *)sender{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self photo];
    }];
    
    UIAlertAction *xiangji = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self camera];
    }];
    [alertController addAction:okAction];
    [alertController addAction:xiangji];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
//相册
- (void)photo
{
    /**
     
     UIImagePickerControllerSourceTypePhotoLibrary ,//来自图库
     UIImagePickerControllerSourceTypeCamera ,//来自相机
     UIImagePickerControllerSourceTypeSavedPhotosAlbum //来自相册
     */
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}
//相机
- (void)camera
{
    //判断是否可以打开相机，模拟器此功能无法使用
    if (![UIImagePickerController isSourceTypeAvailable:
          
          UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:@"没有摄像头" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:nil];
        
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    imagePicker.allowsEditing = YES;
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    /**
     
     选取的信息都在info中，info 是一个字典。
     字典中的键：
     NSString *const  UIImagePickerControllerMediaType ;指定用户选择的媒体类型（文章最后进行扩展）
     NSString *const  UIImagePickerControllerOriginalImage ;原始图片
     NSString *const  UIImagePickerControllerEditedImage ;修改后的图片
     NSString *const  UIImagePickerControllerCropRect ;裁剪尺寸
     NSString *const  UIImagePickerControllerMediaURL ;媒体的URL
     NSString *const  UIImagePickerControllerReferenceURL ;原件的URL
     NSString *const  UIImagePickerControllerMediaMetadata;当来数据来源是照相机的时候这个值才有效
     
     
     */
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]) {
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
//        self.statusImageView.image=image;
        [self.addImageBtn setBackgroundImage:image forState:UIControlStateNormal];
        //如果是拍摄的照片
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            //保存在相册
//            self.statusImageView.image=image;
            [self.addImageBtn setBackgroundImage:image forState:UIControlStateNormal];
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        }
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//发状态
- (void)rightSubmitItemAction:(UIBarButtonItem *)sender{
    NSString *statusContent = [NSString stringWithFormat:@"%@",self.statusTextView.text];
    
    UIImage *image = [self.addImageBtn backgroundImageForState:UIControlStateNormal];
    
    NSData *data = UIImageJPEGRepresentation(image, 0.8);
    
    //将图片保存成AVFile类型先上传到服务器 获取一个url
    AVFile *file = [AVFile fileWithName:@"2.jpeg" data:data];
    
    __block NSString *imageUrl = nil;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"上传中,请等待..." preferredStyle:UIAlertControllerStyleAlert];
    [self showDetailViewController:alert sender:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded){
                imageUrl = file.url;
                
                AVObject *statusClass = [[AVObject alloc]initWithClassName:@"StatusClass"];
                [statusClass setObject:@"dyk" forKey:@"name"];
                [statusClass setObject:statusContent forKey:@"statusContent"];
                [statusClass setObject:imageUrl forKey:@"imageUrl"];
                [statusClass saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if(succeeded){
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                            //刷新页面
                            [SharedHandler SharedHandler].reloadStatusBlock();
                            [self dismissViewControllerAnimated:alert completion:nil];
                            
                            self.tabBarController.tabBar.hidden = NO;
                            self.tabBarController.selectedIndex = 0;
                        });
                    }
                }];
            }
        }];
    });
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
