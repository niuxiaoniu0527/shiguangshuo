//
//  RequestMine.m
//  ShiGuangShuo
//
//  Created by 付莉 on 16/3/18.
//  Copyright © 2016年 Fuli. All rights reserved.
//

#import "RequestMine.h"

@implementation RequestMine



+ (NSMutableArray *)setData{
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"Mine" ofType:@"plist"];
    NSMutableArray *arr = [[NSMutableArray alloc] initWithContentsOfFile:file];
    
    return arr;
}



@end
