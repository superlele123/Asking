//
//  WeatherDesc.m
//  Asking
//
//  Created by Lves Li on 14/12/3.
//  Copyright (c) 2014年 Lves. All rights reserved.
//

#import "WeatherDesc.h"

@implementation WeatherDesc


+(id)weatherDescWithDate:(NSString *)date description:(NSString *)desc wind:(NSString *)wind andTemperature:(NSString *)tem{
    return [[self alloc] initWithDate:date description:desc wind:wind andTemperature:tem];
}


-(instancetype)initWithDate:(NSString *)date description:(NSString *)desc wind:(NSString *)wind andTemperature:(NSString *)tem{
    if (self=[super init]) {
        _date=date;
        _weatherDes=desc;
        _wind=wind;
        _temperature=tem;
    }
    return self;
}



-(instancetype)init{
    if (self=[super init]) {
        
    }
    return self;
}


@end
