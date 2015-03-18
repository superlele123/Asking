//
//  UIColor+Inverse.m
//  MusicDemo
//
//  Created by Lves Li on 15/2/5.
//  Copyright (c) 2015年 Lves. All rights reserved.
//

#import "UIColor+Inverse.h"

@implementation UIColor (Inverse)
-(UIColor*) inverseColor
{
    CGFloat r,g,b,a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return [UIColor colorWithRed:1.-r green:1.-g blue:1.-b alpha:a];
}
@end
