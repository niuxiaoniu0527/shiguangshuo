//
//  CommentVC.h
//  LeanCloudTest
//
//  Created by DYK on 16/3/18.
//  Copyright © 2016年 DYK. All rights reserved.
//


#import <UIKit/UIKit.h>
typedef void(^ReloadCommentBlock)();

@interface CommentVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UITableView *statusListTableView;

@property(nonatomic,strong)NSString *currentStatusId;

@property(nonatomic,strong)ReloadCommentBlock reloadCommentBlock;
@end
