//
//  ColorTool.m
//  MusicDemo
//
//  Created by Lves Li on 15/2/5.
//  Copyright (c) 2015年 Lves. All rights reserved.
//

#import "ColorTool.h"

@implementation ColorTool
#pragma mark  通过图片链接获得平均颜色

+(UIColor *)colorFromImageUrl:(NSString *)imageUrlStr{
    NSURL *url=[NSURL URLWithString:imageUrlStr];
    UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    return [image averageColor];
}




@end
