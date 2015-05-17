//
//  NSString+Contain.m
//  flowofficial
//
//  Created by Lves Li on 15/1/28.
//  Copyright (c) 2015年 Jesse Cheng. All rights reserved.
//

#import "NSString+Contain.h"

@implementation NSString (Contain)

- (BOOL)isContainsString:(NSString *)aString
{
    double systemVersion = [[[UIDevice currentDevice] systemVersion] doubleValue];
    if (systemVersion >= 8)
    {
        return [self containsString:aString];
    }
    BOOL isContain = NO;
    NSRange range = [self rangeOfString:aString];
    if (range.location != NSNotFound && range.length > 0)
    {
        isContain = YES;
    }
    return isContain;
}

@end
