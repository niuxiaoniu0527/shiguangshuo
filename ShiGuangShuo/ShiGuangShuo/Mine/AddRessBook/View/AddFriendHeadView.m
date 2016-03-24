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
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 250) / 2 ,(self.size.height - 40) / 2 , 250, 40)];
        self.textField.placeholder = @"请输入对方ID";
        self.textField.layer.borderWidth = 1.5;
        self.textField.layer.cornerRadius = 15;
        [self addSubview:self.textField];
    }
    return self;
}

@end
