//
//  ColorTool.h
//  MusicDemo
//
//  Created by Lves Li on 15/2/5.
//  Copyright (c) 2015年 Lves. All rights reserved.
//  获得颜色工具类

#import <Foundation/Foundation.h>
#import "UIImage+AverageColor.h"

@interface ColorTool : NSObject
+(UIColor *)colorFromImageUrl:(NSString *)imageUrlStr;
@end
