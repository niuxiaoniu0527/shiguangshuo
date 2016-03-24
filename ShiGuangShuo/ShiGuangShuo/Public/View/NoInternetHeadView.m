//
//  NoInternetHeadView.m
//  ShiGuangShuo
//
//  Created by 常超 on 3/23/16.
//  Copyright © 2016 Fuli. All rights reserved.
//

#import "NoInternetHeadView.h"

@implementation NoInternetHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc] initWithFrame:frame];
        self.label.backgroundColor = [UIColor yellowColor];
        self.label.text = @"无网络连接,请检查网络....";
        self.label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label];
    }
    return self;
}

@end
