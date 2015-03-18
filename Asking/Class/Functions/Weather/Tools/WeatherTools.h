//
//  WeatherTools.h
//  Asking
//
//  Created by Lves Li on 14/12/3.
//  Copyright (c) 2014年 Lves. All rights reserved.
//  请求天气

#import <Foundation/Foundation.h>

@class WeatherModel;
typedef void (^WeatherSuccessBlock) (WeatherModel * weatherModel);
typedef void (^WeatherFaildBlock)(NSError *error);



@interface WeatherTools : NSObject
+(void)getWeatherByCityName:(NSString *)cityName andSuccess:(WeatherSuccessBlock)weatherSuccess andFialure:(WeatherFaildBlock)weatherFaild;
@end
