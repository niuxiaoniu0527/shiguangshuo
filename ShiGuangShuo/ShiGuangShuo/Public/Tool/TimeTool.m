//
//  TimeTool.m
//  ShiGuangShuo
//
//  Created by 常超 on 3/25/16.
//  Copyright © 2016 Fuli. All rights reserved.
//

#import "TimeTool.h"

@implementation TimeTool

+ (NSString *)timeStr:(long long)timestamp{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //获取当前的时间
    NSDate *currentDate = [NSDate date];
    //获取年月日
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay fromDate:currentDate];
    NSInteger currentYear = components.year;
    NSInteger currentMonth = components.month;
    NSInteger currentDay = components.day;
    //获取消息发送的时间
    NSDate *msgDate = [NSDate dateWithTimeIntervalSince1970:timestamp / 1000.0];
    
    components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay fromDate:msgDate];
    CGFloat msgYear = components.year;
    CGFloat msgMonth = components.month;
    CGFloat msgDay = components.day;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if (currentYear == msgYear && currentMonth == msgMonth && currentDay == msgDay) {
        //今天
        dateFormatter.dateFormat = @"HH:mm";
        
    }else if (currentYear == msgYear && currentMonth == msgMonth && currentDay - 1== msgDay){
        //昨天
        dateFormatter.dateFormat = @"昨天 HH:mm";
        
    }else{
        //昨天以前
        dateFormatter.dateFormat = @"yyy-MM-dd HH:mm";
        
    }
    
    return [dateFormatter stringFromDate:msgDate];
}

@end
