//
//  WeatherDesc.h
//  Asking
//
//  Created by Lves Li on 14/12/3.
//  Copyright (c) 2014年 Lves. All rights reserved.
//  每天的天气描述

#import <Foundation/Foundation.h>

@interface WeatherDesc : NSObject
///日期
@property (nonatomic,copy)NSString *date;
///描述
@property (nonatomic,copy)NSString *weatherDes;
///风向
@property (nonatomic,copy)NSString *wind;
///温度
@property (nonatomic,copy)NSString *temperature;

/*
 构造函数
 */
+(id)weatherDescWithDate:(NSString *)date description:(NSString *)desc wind:(NSString *)wind andTemperature:(NSString *)tem;
@end
