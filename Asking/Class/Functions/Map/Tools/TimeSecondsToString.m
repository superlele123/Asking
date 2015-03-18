//
//  TimeSecondsToString.m
//  flowofficial
//
//  Created by Lves Li on 14-8-20.
//  Copyright (c) 2014年 Jesse Cheng. All rights reserved.
//

#import "TimeSecondsToString.h"

@implementation TimeSecondsToString

+(NSString *)secondsToString:(long)second{
   
    
    long hour=second/3600;
    int minute=(second%3600)/60;
    //int newSeconds=second%60;
    NSString *str=[NSString string];
    if (hour>=1) {
        str=[str stringByAppendingFormat:@"%ld小时",hour];
    }
    if (minute>1) {
         str=[str stringByAppendingFormat:@"%d分",minute];
    }
    return str;
    
}


@end
