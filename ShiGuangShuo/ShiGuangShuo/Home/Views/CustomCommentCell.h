//
//  CustomCommentCell.h
//  LeanCloudTest
//
//  Created by DYK on 16/3/21.
//  Copyright © 2016年 DYK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *reviewerLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *commentLbl;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end
