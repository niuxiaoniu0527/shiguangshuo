//
//  SharedHandler.m
//  ShiGuangShuo
//
//  Created by DYK on 16/3/25.
//  Copyright © 2016年 Fuli. All rights reserved.
//

#import "SharedHandler.h"

@implementation SharedHandler

+ (SharedHandler *)SharedHandler{
    static dispatch_once_t onceToken;
    static SharedHandler *shareHandler = nil;
    dispatch_once(&onceToken, ^{
        if(nil == shareHandler){
            shareHandler = [[SharedHandler alloc]init];
        }
    });
    return shareHandler;
}
@end
