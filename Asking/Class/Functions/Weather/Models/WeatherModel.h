//
//  WeatherModel.h
//  Asking
//
//  Created by Lves Li on 14/12/3.
//  Copyright (c) 2014年 Lves. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherDesc.h"



@interface WeatherModel : NSObject
///城市名
@property (nonatomic,copy)NSString *cityName;
///今天的日期
@property (nonatomic,copy)NSString *date;
///pm25
@property (nonatomic,copy)NSString *pm25;
///实时温度
@property (nonatomic,copy)NSString *nowTemperature;



////今天的详情
@property(nonatomic,strong)WeatherDesc *todayWeather;
////明天的详情
@property(nonatomic,strong)WeatherDesc *firstDayWeather;
////后天的详情
@property(nonatomic,strong)WeatherDesc *secondDayWeather;
////第三天的详情
@property(nonatomic,strong)WeatherDesc *thirdDayWeather;


@end
