//
//  AddFriendHeadView.m
//  ShiGuangShuo
//
//  Created by 常超 on 3/23/16.
//  Copyright © 2016 Fuli. All rights reserved.
//

#import "AddFriendHeadView.h"
#import "UIView+SDAutoLayout.h"
@implementation AddFriendHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(35 ,10 , self.frame.size.width - 40, 40)];
        self.textField.placeholder = @"  请输入对方ID";
        self.textField.layer.borderWidth = 1;
        self.textField.layer.cornerRadius = 10;
        self.textField.layer.borderColor = [UIColor blackColor].CGColor;
        UIImageView *searchImageV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 15, 25, 25)];
        searchImageV.image = [UIImage imageNamed:@"search"];
        [self addSubview:searchImageV];
        [self addSubview:self.textField];
    }
    return self;
}

@end
