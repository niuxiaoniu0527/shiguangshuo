//
//  AudioPlayTool.h
//  ShiGuangShuo
//
//  Created by 常超 on 3/25/16.
//  Copyright © 2016 Fuli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioPlayTool : NSObject

+ (void)playWithMessage:(EMMessage *)message messageLable:(UILabel *)messageLable receiver:(BOOL)receiver;

+ (void)stop;
@end
