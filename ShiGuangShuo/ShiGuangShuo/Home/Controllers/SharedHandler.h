//
//  SharedHandler.h
//  ShiGuangShuo
//
//  Created by DYK on 16/3/25.
//  Copyright © 2016年 Fuli. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^ReloadStatusBlock)();
@interface SharedHandler : NSObject
+ (SharedHandler *)SharedHandler;

@property(nonatomic,strong)ReloadStatusBlock reloadStatusBlock;
@end
